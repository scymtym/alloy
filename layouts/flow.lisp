#|
 This file is a part of Alloy
 (c) 2019 Shirakumo http://tymoon.eu (shinmera@tymoon.eu)
 Author: Nicolas Hafner <shinmera@tymoon.eu>
|#

(in-package #:org.shirakumo.alloy)

(defclass flow-layout (layout vector-container)
  ((cell-margins :initarg :cell-margins :initform (margins 5) :accessor cell-margins)
   (align :initarg :align :initform :end :accessor align)
   (min-size :initarg :min-size :initform (size 20 20) :accessor min-size)))

(defmethod notice-size ((element layout-element) (layout flow-layout))
  (refit layout)
  (unless (eq layout (layout-parent layout))
    (notice-size layout T)))

(defmethod suggest-size (size (layout flow-layout))
  (with-unit-parent layout
    (destructure-margins (:l ml :u mu :r mr :b mb :to-px T) (cell-margins layout)
      (let* ((mh (pxh (min-size layout)))
             (mw (pxw (min-size layout)))
             (tw 0.0)
             (th mh))
        (loop for element across (elements layout)
              do (let ((size (suggest-size (px-size mw th) element)))
                   (when (and (< 0 (pxw size)) (< 0 (pxh size)))
                     (incf tw (+ (pxw size) ml mr))
                     (setf th (max (pxh size) th)))))
        (px-size tw (+ mb mu th))))))

(defmethod refit ((layout flow-layout))
  (with-unit-parent layout
    (destructure-margins (:l ml :u mu :r mr :b mb :to-px T) (cell-margins layout)
      (destructure-extent (:w w :h h :to-px T) (bounds layout)
        (let* ((mh (pxh (min-size layout)))
               (mw (pxw (min-size layout)))
               (y (ecase (align layout)
                    (:start mb)
                    (:end (- mu))))
               (x ml)
               (rh mh)
               (th 0.0)
               (elements (elements layout))
               (i 0))
          (loop while (< i (length elements))
                for element = (aref elements i)
                for size = (suggest-size (px-size mw rh) element)
                for ew = (pxw size)
                for eh = (pxh size)
                do (cond ((and (< 0 ew) (< 0 eh))
                          (setf rh (max rh eh))
                          (let ((ey (ecase (align layout)
                                      (:start y)
                                      (:end (- y eh)))))
                            (cond ((< w (+ x ew ml))
                                   ;; Row overflow, flush row.
                                   (if (= x ml)
                                       (setf (bounds element) (px-extent x ey (- w ml mr) eh))
                                       (decf i))
                                   (ecase (align layout)
                                     (:start (incf y (+ rh mu mb)))
                                     (:end (decf y (+ rh mu mb))))
                                   (setf x ml)
                                   (incf th (+ rh mu mb))
                                   (setf rh mh))
                                  (T
                                   (setf (bounds element) (px-extent x ey ew eh))
                                   (incf x (+ ew ml mr))))))
                         (T
                          (setf (bounds element) (px-extent 0 0 0 0))))
                   (incf i))
          (ecase (align layout)
            (:end
             (loop for element across elements
                   do (setf (y element) (u+ (y element) (max h (+ th mu mb (pxh element))))))))
          (incf th (+ rh mu mb))
          (setf (h layout) (max h th)))))))

(defmethod (setf bounds) :after (extent (layout flow-layout))
  (refit layout))
