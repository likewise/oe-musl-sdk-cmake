#include <stdio.h>

static int test(void)
{
  int a = 7;
  int b = 6;
  return a * b;
}

int main(int argc, char *argv[])
{
  int result = test();
  printf("Hello world\n");
  return result;
}
