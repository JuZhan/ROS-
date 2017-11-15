# generated from genmsg/cmake/pkg-genmsg.cmake.em

message(STATUS "moving: 1 messages, 0 services")

set(MSG_I_FLAGS "-Imoving:/home/juzhan/ros/workspace/my_ws/src/moving/msg;-Imoving:/home/juzhan/ros/workspace/my_ws/src/moving/msg")

# Find all generators
find_package(gencpp REQUIRED)
find_package(genlisp REQUIRED)
find_package(genpy REQUIRED)

add_custom_target(moving_generate_messages ALL)

# verify that message/service dependencies have not changed since configure



get_filename_component(_filename "/home/juzhan/ros/workspace/my_ws/src/moving/msg/hello.msg" NAME_WE)
add_custom_target(_moving_generate_messages_check_deps_${_filename}
  COMMAND ${CATKIN_ENV} ${PYTHON_EXECUTABLE} ${GENMSG_CHECK_DEPS_SCRIPT} "moving" "/home/juzhan/ros/workspace/my_ws/src/moving/msg/hello.msg" ""
)

#
#  langs = gencpp;genlisp;genpy
#

### Section generating for lang: gencpp
### Generating Messages
_generate_msg_cpp(moving
  "/home/juzhan/ros/workspace/my_ws/src/moving/msg/hello.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/moving
)

### Generating Services

### Generating Module File
_generate_module_cpp(moving
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/moving
  "${ALL_GEN_OUTPUT_FILES_cpp}"
)

add_custom_target(moving_generate_messages_cpp
  DEPENDS ${ALL_GEN_OUTPUT_FILES_cpp}
)
add_dependencies(moving_generate_messages moving_generate_messages_cpp)

# add dependencies to all check dependencies targets
get_filename_component(_filename "/home/juzhan/ros/workspace/my_ws/src/moving/msg/hello.msg" NAME_WE)
add_dependencies(moving_generate_messages_cpp _moving_generate_messages_check_deps_${_filename})

# target for backward compatibility
add_custom_target(moving_gencpp)
add_dependencies(moving_gencpp moving_generate_messages_cpp)

# register target for catkin_package(EXPORTED_TARGETS)
list(APPEND ${PROJECT_NAME}_EXPORTED_TARGETS moving_generate_messages_cpp)

### Section generating for lang: genlisp
### Generating Messages
_generate_msg_lisp(moving
  "/home/juzhan/ros/workspace/my_ws/src/moving/msg/hello.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/moving
)

### Generating Services

### Generating Module File
_generate_module_lisp(moving
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/moving
  "${ALL_GEN_OUTPUT_FILES_lisp}"
)

add_custom_target(moving_generate_messages_lisp
  DEPENDS ${ALL_GEN_OUTPUT_FILES_lisp}
)
add_dependencies(moving_generate_messages moving_generate_messages_lisp)

# add dependencies to all check dependencies targets
get_filename_component(_filename "/home/juzhan/ros/workspace/my_ws/src/moving/msg/hello.msg" NAME_WE)
add_dependencies(moving_generate_messages_lisp _moving_generate_messages_check_deps_${_filename})

# target for backward compatibility
add_custom_target(moving_genlisp)
add_dependencies(moving_genlisp moving_generate_messages_lisp)

# register target for catkin_package(EXPORTED_TARGETS)
list(APPEND ${PROJECT_NAME}_EXPORTED_TARGETS moving_generate_messages_lisp)

### Section generating for lang: genpy
### Generating Messages
_generate_msg_py(moving
  "/home/juzhan/ros/workspace/my_ws/src/moving/msg/hello.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/moving
)

### Generating Services

### Generating Module File
_generate_module_py(moving
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/moving
  "${ALL_GEN_OUTPUT_FILES_py}"
)

add_custom_target(moving_generate_messages_py
  DEPENDS ${ALL_GEN_OUTPUT_FILES_py}
)
add_dependencies(moving_generate_messages moving_generate_messages_py)

# add dependencies to all check dependencies targets
get_filename_component(_filename "/home/juzhan/ros/workspace/my_ws/src/moving/msg/hello.msg" NAME_WE)
add_dependencies(moving_generate_messages_py _moving_generate_messages_check_deps_${_filename})

# target for backward compatibility
add_custom_target(moving_genpy)
add_dependencies(moving_genpy moving_generate_messages_py)

# register target for catkin_package(EXPORTED_TARGETS)
list(APPEND ${PROJECT_NAME}_EXPORTED_TARGETS moving_generate_messages_py)



if(gencpp_INSTALL_DIR AND EXISTS ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/moving)
  # install generated code
  install(
    DIRECTORY ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/moving
    DESTINATION ${gencpp_INSTALL_DIR}
  )
endif()
if(TARGET moving_generate_messages_cpp)
  add_dependencies(moving_generate_messages_cpp moving_generate_messages_cpp)
endif()

if(genlisp_INSTALL_DIR AND EXISTS ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/moving)
  # install generated code
  install(
    DIRECTORY ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/moving
    DESTINATION ${genlisp_INSTALL_DIR}
  )
endif()
if(TARGET moving_generate_messages_lisp)
  add_dependencies(moving_generate_messages_lisp moving_generate_messages_lisp)
endif()

if(genpy_INSTALL_DIR AND EXISTS ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/moving)
  install(CODE "execute_process(COMMAND \"/usr/bin/python\" -m compileall \"${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/moving\")")
  # install generated code
  install(
    DIRECTORY ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/moving
    DESTINATION ${genpy_INSTALL_DIR}
  )
endif()
if(TARGET moving_generate_messages_py)
  add_dependencies(moving_generate_messages_py moving_generate_messages_py)
endif()
