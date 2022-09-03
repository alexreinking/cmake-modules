#include "config.h"

#include <iostream>

int main(int argc, char *argv[]) {
  std::cout << argv[0] << " version " << EXAMPLE_VERSION_STRING << "\n";
  return 0;
}
