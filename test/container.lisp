#|
 This file is a part of Alloy
 (c) 2019 Shirakumo http://tymoon.eu (shinmera@tymoon.eu)
 Author: Nicolas Hafner <shinmera@tymoon.eu>
|#

(in-package #:org.shirakumo.alloy.test)

(define-test container
  :parent alloy)

(defun set= (a b)
  (null (set-exclusive-or a b)))

(define-test vector-container
  :parent container
  (let ((container (make-instance 'alloy:vector-container))
        (elm1 (make-instance 'alloy:element))
        (elm2 (make-instance 'alloy:element))
        (elm3 (make-instance 'alloy:element)))
    (is = 0 (length (alloy:elements container)))
    (is eq elm1 (alloy:enter elm1 container))
    (is eq elm2 (alloy:enter elm2 container))
    (is = 2 (length (alloy:elements container)))
    (is set= (list elm1 elm2)
        (let ((list ()))
          (alloy:do-elements (element container :result list)
            (push element list))))
    (is eq elm2 (alloy:leave elm2 container))
    (is = 1 (length (alloy:elements container)))
    (is eq elm3 (alloy:enter elm3 container))
    (is = 2 (length (alloy:elements container)))
    (is set= (list elm1 elm3)
        (let ((list ()))
          (alloy:do-elements (element container :result list)
            (push element list))))
    (is eq elm1 (alloy:update elm1 container :index 1))
    (is set= (list elm1 elm3)
        (let ((list ()))
          (alloy:do-elements (element container :result list)
            (push element list))))))
