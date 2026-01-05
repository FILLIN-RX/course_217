# Additional clean files
cmake_minimum_required(VERSION 3.16)

if("${CONFIG}" STREQUAL "" OR "${CONFIG}" STREQUAL "Debug")
  file(REMOVE_RECURSE
  "CMakeFiles\\appcourse_217_autogen.dir\\AutogenUsed.txt"
  "CMakeFiles\\appcourse_217_autogen.dir\\ParseCache.txt"
  "appcourse_217_autogen"
  )
endif()
