; Auto-generated. Do not edit!


(cl:in-package moving-msg)


;//! \htmlinclude hello.msg.html

(cl:defclass <hello> (roslisp-msg-protocol:ros-message)
  ((myData
    :reader myData
    :initarg :myData
    :type cl:string
    :initform ""))
)

(cl:defclass hello (<hello>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <hello>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'hello)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name moving-msg:<hello> is deprecated: use moving-msg:hello instead.")))

(cl:ensure-generic-function 'myData-val :lambda-list '(m))
(cl:defmethod myData-val ((m <hello>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader moving-msg:myData-val is deprecated.  Use moving-msg:myData instead.")
  (myData m))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <hello>) ostream)
  "Serializes a message object of type '<hello>"
  (cl:let ((__ros_str_len (cl:length (cl:slot-value msg 'myData))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) __ros_str_len) ostream))
  (cl:map cl:nil #'(cl:lambda (c) (cl:write-byte (cl:char-code c) ostream)) (cl:slot-value msg 'myData))
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <hello>) istream)
  "Deserializes a message object of type '<hello>"
    (cl:let ((__ros_str_len 0))
      (cl:setf (cl:ldb (cl:byte 8 0) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:slot-value msg 'myData) (cl:make-string __ros_str_len))
      (cl:dotimes (__ros_str_idx __ros_str_len msg)
        (cl:setf (cl:char (cl:slot-value msg 'myData) __ros_str_idx) (cl:code-char (cl:read-byte istream)))))
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<hello>)))
  "Returns string type for a message object of type '<hello>"
  "moving/hello")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'hello)))
  "Returns string type for a message object of type 'hello"
  "moving/hello")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<hello>)))
  "Returns md5sum for a message object of type '<hello>"
  "319d8b4b8bf8dbac63eb8b2643cce814")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'hello)))
  "Returns md5sum for a message object of type 'hello"
  "319d8b4b8bf8dbac63eb8b2643cce814")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<hello>)))
  "Returns full string definition for message of type '<hello>"
  (cl:format cl:nil "string myData~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'hello)))
  "Returns full string definition for message of type 'hello"
  (cl:format cl:nil "string myData~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <hello>))
  (cl:+ 0
     4 (cl:length (cl:slot-value msg 'myData))
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <hello>))
  "Converts a ROS message object to a list"
  (cl:list 'hello
    (cl:cons ':myData (myData msg))
))
