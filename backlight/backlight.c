/**
 *
 * @mainpage Backlight
 *
 * @section Introduction
 * This program is a command line program that allows the brightness level of
 * an Intel video system to be read, set, incremented or decremented.
 * 
 * It will read and write @a /sys/class/backlight/intel_backlight/brightness
 * to establish the current backlight brightness and can write to that file to change 
 * the brightness.
 * 
 * To establish the maximum allowed brightness, it will read
 * @a /sys/class/backlight/intel_backlight/max_brightness
 * 
 * @author Eric Waller
 *
 * @date September 2015
 *
 * @copyright 
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 * 
 * @section Usage 
 * backlight [OPTION...]
 * Option          | Description
 * --------------- | --------------
 *   -d, --dec=INT | Decrement
 *   -i, --inc=INT | Increment
 *   -s, --set=INT | Set
 *   -v, --verbose | Produce verbose output
 *   -?, --help    | Give this help list
 *       --usage   | Give a short usage message
 *   -V, --version | Print program version
 * 
 * The program will report the maximum permitted brightness and the 
 * brightness setting when the program exits
 */

#include <stdlib.h>
#include <stdio.h>
#include <argp.h>

/**
 * Stores the values of the program options that are passed
 * in from the command line.  The values initially set to invalid values by
 * main and are updated as the command line parameters are parsed.  It is 
 * only permissible to specify one of inc, dec, or set.
 */
typedef struct {
  int verbose; /**< If set, be verbose */
  int inc;  /**< Value by which to increment the brightness */
  int dec;  /**< Value by which to decrement the brightness */
  int set;  /**< Value by which to set the brightness */ 
} ProgramArguments;

static ProgramArguments arguments;

///  Define the acceptable command line options

static struct argp_option options[] =               
{
  {"verbose", 'v', 0, 0, "Produce verbose output"},  /**< The verbose command line flag has no argument */
  {"inc", 'i', "INT",0,"Increment"},                 ///< increment command line flag requires an integer argument
  {"dec", 'd', "INT",0,"Decrement"},                 ///< decrement command line flag requires an integer argument
  {"set", 's', "INT",0,"Set"},                       ///< decrement command line flag requires an integer argument
  {0}
};

const char *argp_program_version = "backlight 0.1";
const char *argp_program_bug_address = "<ewwaller+code@gmail.com>";
static char doc[] =
  "backlight -- Read, set, increment, or decrement the backlight on Intel graphics based displays";

static char args_doc[] = "";
static error_t parse_opt (int key, char *arg, struct argp_state *state);

static struct argp argp = { options, parse_opt, args_doc, doc };


int
ReadSysFile(char *theFileName)
{
  /**  Read a file from @a /sys and interpret the data on the first line of 
   *   the "file" as an integer expresed as a ascii decimal string 
   *   
   *   @param[in] *theFileName A zero terminated string containing the name and
   *                           path of the sys file
   *   @return the integer value read from the file.  -1 indicates failure. 
   */

  char* readBuffer = NULL;
  long unsigned int  bufferSize = 0;
  
  FILE *theFile = fopen(theFileName,"r");
  if (!theFile)
    {
      fprintf(stderr,"\nCould not open the file %s\n",theFileName);
      return -1;
    }
  
  getline(&readBuffer, &bufferSize, theFile);
  if (readBuffer)
    {
      int theIntValue=atoi(readBuffer);
      free(readBuffer);
      readBuffer=NULL;
      bufferSize=0;
      fclose(theFile);
      return (theIntValue);
    }
  fclose(theFile);
  return -1;
}

int
WriteSysFile(char *theFileName, int theValue)
{
  /**  
   *   Write a file from /sys an interpret the data on the first line of the "file" as an integer expresed as a ascii decimal string 
   *    
   *   @param[in] *theFileName A pointer to a zero terminated string containing the 
   *                           name and path of the sys file
   *    @param[in] theValue    The value to be written to the file
   *    @return                0 or positive integer is success;  negative integer is failure
  */

  FILE *theFile = fopen(theFileName,"w");
  if (!theFile)
    {
      fprintf(stderr,"\nCould not open the file %s\n",theFileName);
      return -1;
    }
  int returnValue;
  returnValue = fprintf(theFile,"%i\n",theValue);
  fclose(theFile);
  return returnValue;
}

int
parseIntArgument(char *arg)
{
  /**
   *  Convert a null terminated string of decimal digits to an integer.  Any non-decimal 
   *  digits in the string will result in a failure.
   *  
   *  @param[in] arg A pointer to null terminated string of decimal digits
   *  @return A positive or zero integer represented by the string. 
   *  @warning An error condition will cause the program to exit with an error.
   */
  
  char *endptr, *str;
  long val;
  errno = 0;    /* To distinguish success/failure after call */
  val = strtol(arg, &endptr, 10);
  if ((errno == ERANGE && (val == LONG_MAX || val == LONG_MIN))
      || (errno != 0 && val == 0))
    {
      perror("strtol");
      exit(EXIT_FAILURE);
    }
  
  if (endptr == str) {
    fprintf(stderr, "No digits were found\n");
    exit(EXIT_FAILURE);
  }
  if (*endptr)
    {+
      printf ("Non digit in decimal value\n");
      exit(EXIT_FAILURE);
    }
  /* If we got here, strtol() successfully parsed a number */
  return (int)val;
}

void
TooManyOptions(void)
{
  /**
   * A simple helper function that prints an error message and exits
   * @warning Calling this function causes the program to exit with an error.
   */

  printf("Increment, Decrement and Set are mutually exclusive options\n");
  exit(EXIT_FAILURE);
}

static error_t
parse_opt (int key, char *arg, struct argp_state *state)
{
  /**
   *  Process the command line arguments and options.  Collect all 
   *  the options and remember their state. This function is called one
   *  time for each key.  As the keys are passed in, check to ensure they
   *  do not conflict with each other.  When there are no more keys, 
   *  ensure there are no additional parameters that were passed into the 
   *  program -- this one does not want any.
 x  *
   *  @param[in]     key    An integer that represents a char value of one 
   *                        of options passed from the command line.
   *  @param[in,out] *arg   A pointer to a null terminated string that is the argument of the 
   *                        option represented by key.
   *  @param[in]     *state  
   */
  
  ProgramArguments* argumentPtr = state->input;
  
  switch (key)
    {
    case 'v':
      argumentPtr->verbose = 1;
      break;
    case 'i':
      if ((arguments.dec != -1) || (arguments.set != -1))
	TooManyOptions();
      arguments.inc=parseIntArgument(arg);
      break;
    case 'd':
      if ((arguments.inc != -1) || (arguments.set != -1))
	TooManyOptions();
      arguments.dec=parseIntArgument(arg);
      break;
    case 's':
      if ((arguments.dec != -1) || (arguments.inc != -1))
	TooManyOptions();
      arguments.set=parseIntArgument(arg);
      break;
    case ARGP_KEY_NO_ARGS:
      /* If there are no Arguments, that is good.  We don't want any */
      break;
    case ARGP_KEY_ARG:
      /* I am not expecting any arguments that are not options. */
      argp_usage (state);
      break;
    default:
      return ARGP_ERR_UNKNOWN;
    }
  return 0;
}

int
main (int argc, char** argv)
{
  /**
   * This is the main function.   
   * line.  It will determine the maximum brightness permitted, and the current brightness,
   * and will parse the parameters passed in on the command and determine their validity.  If
   * they are valid, and they call for a change in the brightness setting, it will write to the
   * appropriate system file to cause the brightness to change.  
   *
   *  @param[in]  argc    An integer that represents the number of command line parameters.
   *  @param[in]  **argv  A pointer to an array of pointers to null terminated strings that store
   *                      the parameters on the command line.
   *  @return             An integer that represents the exit value of the program.  0 means success.
   */
  
  arguments.verbose = 0;
  arguments.set = -1;
  arguments.inc = -1;
  arguments.dec = -1;
  
  int max_brightness = 0;
  int brightness =0;
  max_brightness = ReadSysFile("/sys/class/backlight/intel_backlight/max_brightness");
  if (max_brightness < 0)
    exit(EXIT_FAILURE);
  brightness = ReadSysFile("/sys/class/backlight/intel_backlight/brightness");
  if (brightness < 0)
    exit(EXIT_FAILURE);
  argp_parse (&argp, argc, argv, 0, 0, &arguments);
  if (arguments.inc >= 0 ) brightness += arguments.inc;
  if (arguments.dec >= 0 ) brightness -= arguments.dec;
  if (arguments.set >= 0 ) brightness  = arguments.set;
  if (brightness<0) brightness = 0;
  if (brightness>max_brightness) brightness = max_brightness;
  if ((arguments.inc >= 0) || (arguments.dec >= 0) || (arguments.set >= 0))
    if (WriteSysFile("/sys/class/backlight/intel_backlight/brightness",brightness) < 0)
      printf("Unable to set brightness.  Check permissions");
  printf("Max Brightness = %i\n",max_brightness);
  printf("Current Brightness = %i\n",brightness);
  if (arguments.verbose)
    {
      printf("Increment:%i; Decrement:%i, Set:%i\n",arguments.inc,arguments.dec,arguments.set);
    }
}

