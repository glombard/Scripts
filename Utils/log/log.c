// A silly small utility that appends the arguments to a log file at: %TEMP%\log.txt

#include <stdio.h>
#include <time.h>
#include <windows.h>

int main(int argc, char* argv[])
{
	time_t t;
	struct tm *now;
	char buffer[MAX_PATH+1];
	char file_name[MAX_PATH+1];

	time(&t);
	now = localtime(&t);

	strftime(buffer, 20, "%F %T", now);
	
	for (int n = 1; n < argc; n++)
	{
		strcat(buffer, " ");
		strcat(buffer, argv[n]);
	}

	puts(buffer);

	GetTempPath(MAX_PATH, file_name);
	strcat(file_name, "\\log.txt");
	FILE *file = fopen(file_name, "a");
	if (file != NULL)
	{
		fputs(buffer, file);
		fputs("\n", file);
		fclose(file);
	}
	return 0;
}
