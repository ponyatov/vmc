/// @file @brief Virtual Machine Compiled (headers)
#pragma once

#include <stdio.h>
#include <stdlib.h>
#include <assert.h>

/// @defgroup main main
/// @{

/// @brief program entry point (POSIX/UNIX)
/// @param[in] argc number of arguments
/// @param[in] argv argument values (including program binary name)
int main(int argc, char* argv[]);

/// @brief print command line argument `argv[index] = <value>`
/// @param[in] argc index
/// @param[in] argv value
void arg(int argc, char* argv);

/// @}
