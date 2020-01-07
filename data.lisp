#|
 This file is a part of Alloy
 (c) 2019 Shirakumo http://tymoon.eu (shinmera@tymoon.eu)
 Author: Nicolas Hafner <shinmera@tymoon.eu>
|#

(in-package #:org.shirakumo.alloy)

(defclass data (observable)
  ())

(defgeneric refresh (data))
(defgeneric expand-place-data (place))
(defgeneric expand-compound-place-data (place args))

(defmethod expand-place-data ((place cons))
  (expand-compound-place-data (first place) (rest place)))

(defmacro place-data (place)
  (expand-place-data place))

(defclass value-data (data)
  ((value :initarg :value :accessor value)))

(defgeneric value (data))
(defgeneric (setf value) (new-value data))
(make-observable '(setf value) '(new-value observable))

(defmethod value ((string string)) string)

(defmethod refresh ((data value-data))
  (notify-observers '(setf value) data (value data) data))

(defmethod expand-place-data (atom)
  `(make-instance 'value-data :value ,atom))

;;; General case.
(defclass place-data (value-data)
  ((getter :initarg :getter :initform (arg! :getter) :accessor getter)
   (setter :initarg :setter :initform (arg! :setter) :accessor setter)))

(defmethod value ((data place-data))
  (funcall (getter data)))

(defmethod (setf value) (new-value (data place-data))
  (funcall (setter data) new-value))

(defmethod expand-compound-place-data ((place symbol) args)
  (let ((value (gensym "VALUE")))
    `(make-instance 'place-data
                    :getter (lambda () (,place ,@args))
                    :setter (lambda (,value) (setf (,place ,@args) ,value)))))

(defmethod expand-place-data ((place symbol))
  (let ((value (gensym "VALUE")))
    `(make-instance 'place-data
                    :getter (lambda () ,place)
                    :setter (lambda (,value) (setf ,place ,value)))))

(defclass slot-data (value-data)
  ((object :initarg :object :initform (arg! :object) :accessor object)
   (slot :initarg :slot :initform (arg! :slot) :accessor slot)))

(defmethod initialize-instance :after ((data slot-data) &key)
  (when (typep (object data) 'observable-object)
    (observe (slot data) (object data) (lambda (value object)
                                         (notify-observers '(setf value) data value object)))))

(defmethod value ((data slot-data))
  (slot-value (object data) (slot data)))

(defmethod (setf value) (new-value (data slot-data))
  (setf (slot-value (object data) (slot data)) new-value))

(defmethod expand-compound-place-data ((place (eql 'slot-value)) args)
  (destructuring-bind (object slot) args
    `(make-instance 'slot-data :object ,object :slot ,slot)))

(defclass aref-data (value-data)
  ((object :initarg :object :initform (arg! :object) :accessor object)
   (index :initarg :index :initform (arg! :index) :accessor index)))

(defmethod value ((data aref-data))
  (row-major-aref (object data) (index data)))

(defmethod (setf value) (new-value (data aref-data))
  (setf (row-major-aref (object data) (index data)) new-value))

(defmethod expand-compound-place-data ((place (eql 'aref)) args)
  (let ((object (gensym "OBJECT")))
    `(let ((,object ,(first args)))
       (make-instance 'aref-data :object ,object :index (array-row-major-index ,object ,@(rest args))))))

(defmethod (setf index) ((list list) (data aref-data))
  (setf (index data) (apply #'array-row-major-index (object data) list)))

;;; TODO: This is kinda... not too great.
(defclass computed-data (value-data)
  ((closure :initarg :closure :accessor closure)))

(defmethod initialize-instance :after ((data computed-data) &key observe)
  (flet ((update (&rest _)
           (declare (ignore _))
           (setf (value data) (apply (closure data)
                                     (loop for (function object) in observe
                                           collect (funcall function object))))))
    (loop for (function object) in observe
          do (observe function object #'update))
    (update)))

(defmethod expand-compound-place-data ((place (eql 'lambda)) args)
  (destructuring-bind (args &rest body) args
    `(make-instance 'computed-data
                    :closure (,place ,(mapcar #'first args) ,@body)
                    :observe (list ,@(loop for (function object) in (mapcar #'second args)
                                           collect `(list ',function ,object))))))

(defclass sequence-data (data)
  ((value :initarg :sequence :initform (arg! :sequence) :reader value)))

(defgeneric element (data index))
(defgeneric (setf element) (value data index))
(defgeneric count (data))
(defgeneric push-element (value data &optional index))
(defgeneric pop-element (data &optional index))
(make-observable '(setf element) '(value observable index))
(make-observable 'push-element '(value observable &optional index))
(make-observable 'pop-element '(observable &optional index))

;; Defaults for a generic version with support for extensible sequences without having to
;; explicitly depend on that protocol
(defmethod element ((data sequence-data) (index integer))
  (elt (value data) index))

(defmethod (setf element) (value (data sequence-data) (index integer))
  (setf (elt (value data) index) value))

(defmethod count ((data sequence-data))
  (length (value data)))

(defclass list-data (sequence-data)
  ((value :initarg :list :initform (arg! :list) :reader value)
   (count :reader count)))

(defmethod initialize-instance :after ((data list-data) &key list)
  (setf (slot-value data 'count) (length list)))

(defmethod shared-initialize :before ((data list-data) slots &key (list NIL list-p))
  (when list-p
    (check-type list list)))

(defmethod refresh ((data list-data))
  (setf (slot-value data 'count) (length (value data))))

(defmethod element ((data list-data) (index integer))
  (nth index (value data)))

(defmethod (setf element) (value (data list-data) (index integer))
  (setf (nth index (value data)) value))

(defmethod push-element (value (data list-data) &optional index)
  (if (and index (< 0 index))
      (let ((cons (nthcdr (1- index) (value data))))
        (setf (cdr cons) (list* value (cddr cons))))
      (push value (value data)))
  (incf (slot-value data 'count)))

(defmethod pop-element ((data list-data) &optional index)
  (decf (slot-value data 'count))
  (if (and index (< 0 index))
      (let ((cons (nthcdr (1- index) (value data))))
        (prog1 (cadr cons)
          (setf (cdr cons) (cddr cons))))
      (pop (value data))))

(defclass vector-data (sequence-data)
  ((value :initarg :vector :initform (arg! :vector) :reader value)))

(defmethod shared-initialize :before ((data vector-data) slots &key (vector NIL vector-p))
  (when vector-p
    (check-type vector vector)))

(defmethod element ((data vector-data) (index integer))
  (aref (value data) index))

(defmethod (setf element) (value (data vector-data) (index integer))
  (setf (aref (value data) index) value))

(defmethod push-element (value (data list-data) &optional index)
  (if index
      (array-utils:vector-push-extend-position value (value data) index)
      (vector-push-extend value (value data))))

(defmethod pop-element ((data list-data) &optional index)
  (if index
      (array-utils:vector-pop-position (value data) index)
      (vector-pop (value data))))
