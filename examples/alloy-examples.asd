#|
 This file is a part of Alloy
 (c) 2019 Shirakumo http://tymoon.eu (shinmera@tymoon.eu)
 Author: Nicolas Hafner <shinmera@tymoon.eu>
|#

(asdf:defsystem alloy-examples
  :version "0.0.0"
  :license "zlib"
  :author "Nicolas Hafner <shinmera@tymoon.eu>"
  :maintainer "Nicolas Hafner <shinmera@tymoon.eu>"
  :description "Example programs using Alloy"
  :homepage "https://github.com/Shirakumo/alloy"
  :serial T
  :components ((:file "package")
               (:file "toolkit")
               (:file "windows")
               (:file "drop")
               (:file "constraint")
               (:file "animation")
               (:file "menu")
               (:file "font-mixing")
               (:file "fonts"))
  :depends-on (:alloy-glfw
               :alloy-constraint))
