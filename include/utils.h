typedef struct {
  char vendor[13];
  unsigned int family;
  unsigned int model;
  unsigned int stepping;

  unsigned char has_sse;
  unsigned char has_sse2;
  unsigned char has_sse3;
  unsigned char has_ssse;
  unsigned char has_sse4_1;
  unsigned char has_aes;
  unsigned char has_sha;
} CPUIType;

void clear();
int input(char *buffer, int max_length, int line, int col_start);
unsigned int print(char *message, unsigned int line, void *var);
int input(char *buffer, int max_len, int line, int col_start);
void sh(int line, char buffer[]);

extern CPUIType get_cpu_info();
