// code en revision 0.1.2
// Dernière révision le 02.06.2020
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <sys/types.h>
#include <limits.h>
#include <time.h>
//#define _POSIX_C_SOURCE  2
#define RED "\x1B[31m"
#define GREEN "\x1B[32m"
#define MAG "\x1B[35m"
#define RESET "\x1B[0m"
char periph[1];
char user[50];


void verif_fichier(char *chemin)
{
FILE * test_fichier = fopen(chemin, "r+");

if (test_fichier == NULL)
{
  printf("[");
  printf(RED "Failed" RESET);
  printf("]: ");
  printf("Veuillez verifier l'existence ou les permissions du fichier :\n");
  printf(chemin);
  printf("\n");
  exit (1);
}
}

void usage(void)
{
	printf("Utilisation:\n");
  printf("Débloquer les ports USB, le Bluetooth ou le wifi :\n");
	printf("\t -u \n");
  printf("Bloquer les ports USB, le Bluetooth ou le wifi: \n");
	printf("\t -l \n");
	printf("Pour obtenir plus d'aide : \n");
	printf("\tseclocker -h\n");
  printf("Afficher les blocages: \n");
  printf("\t -a \n");
	exit (8);
}

int main(int argc, char *argv[], int user, int test)
{
register struct passwd *pw;
register uid_t uid;
int c;
int wifilock;
int usblock;
int bluetoothlock;
 uid = geteuid();

if (uid == 0)
{
	if (argv[1] == NULL)
		{
			usage();
		}
	while ((argc > 1) && (argv[1][0] == '-'))
	{
		switch (argv[1][1])
		{
			case ' ':
			usage();
			break;
			return(0);

			case '-help':
			usage();
			break;
			return(0);

			case 'l':

			if (argv[1] == NULL)
			{
				usage();
				return (0);
			}
      else
      {

        printf("\nEntrez le numéro du périphérique a bloquer :\n");
        printf("\n1) - Wifi\n");
        printf("2) - USB\n");
        printf("3) - Bluetooth\n");
        printf("\n[Seclocker]: ");
        scanf( "%s", periph );
        if (strcmp (periph, "1")== 0)
        {
          FILE* usb = NULL;
          usb = fopen("/etc/modprobe.d/blacklist.conf", "a+");
          if (usb != NULL)
              {
                  fputs("install iwlwifi /bin/true\n", usb);
                  fclose(usb);
              }
          system("modprobe iwlwifi");
          printf("[");
          printf(GREEN "Lock" RESET);
          printf("]: ");
          printf("La connexion wifi a bien été arrêtée. \n");
          int i=0;
          int f=10;
          while(i<10)
          {
              fflush(stdout);
              i++;
              f--;
           printf("%i Avant redémarrage... \r",f);
           sleep(1);
          }

          system("reboot");
        }
        else if(strcmp (periph, "2")== 0)
        {
          verif_fichier("/etc/modprobe.d/blacklist.conf");
          FILE* usb = NULL;
          usb = fopen("/etc/modprobe.d/blacklist.conf", "a+");
          if (usb != NULL)
              {
                  fputs("install usb-storage /bin/true\n", usb);
                  fclose(usb);
              }
          system("modprobe usb-storage");
          printf("[");
          printf(GREEN "Lock" RESET);
          printf("]: ");
          printf("Les ports USB ont bien été bloqués. \n");
          int i=0;
          int f=10;
          while(i<10)
          {
              fflush(stdout);
              i++;
              f--;
           printf("%i Avant redémarrage... \r",f);
           sleep(1);
          }

          system("reboot");
        }
        else if(strcmp (periph, "3")== 0)
        {
          verif_fichier("/etc/modprobe.d/blacklist.conf");
          FILE* usb = NULL;
          usb = fopen("/etc/modprobe.d/blacklist.conf", "a+");
          if (usb != NULL)
            {
                fputs("install bluetooth /bin/true\n", usb);
                fclose(usb);
            }
          system("modprobe bluetooth");
          printf("[");
          printf(GREEN "Lock" RESET);
          printf("]: ");
          printf("La connexion Bluetooth a bien été arrêtée.\n");
          int i=0;
          int f=10;
          while(i<10)
          {
              fflush(stdout);
              i++;
              f--;
            printf("%i Avant redémarrage...\r", f);
            sleep(1);
          }
          system("reboot");
        }
        else
        {
          printf("[");
          printf(RED "Failed" RESET);
          printf("]: ");
          printf("Périphérique inconnu.\n");
          return(1);
        }
      }

	break;
	case 'v':
			printf ("\nWifisec version 0.1.2\n");
			return 0;
			break;
	case 'h':
      usage();
			return 0;
			break;
	case 'u':
      printf("\nEntrez le numéro du périphérique à débloquer :\n");
      printf("\n1) - Wifi \n");
      printf("2) - USB\n");
      printf("3) - Bluetooth\n");
      printf("\n[Seclocker]: ");
      scanf( "%s", periph );
      if (strcmp (periph, "1")== 0)
      {
        system("sed -i  '/iwlwifi/d' /etc/modprobe.d/blacklist.conf");
        system("modprobe iwlwifi");
        printf("[");
        printf(GREEN "Unlock" RESET);
        printf("]: ");
        printf("Le wifi a été débloqué. \n");
        printf("Un reboot peut être nécessaire pour réactiver cette fonctionnalité.\n");
      }
      else if(strcmp (periph, "2")== 0)
      {
        system("sed -i  '/usb/d' /etc/modprobe.d/blacklist.conf");
        system("modprobe usb-storage");
        printf("[");
        printf(GREEN "Unlock" RESET);
        printf("]: ");
        printf("Les ports USB ont bien été débloqués. \n");
        printf("Un reboot peut être nécessaire pour réactiver cette fonctionnalité.\n");
      }
      else if(strcmp(periph, "3")== 0)
      {
        system("sed -i '/bluetooth/d' /etc/modprobe.d/blacklist.conf");
        system("modprobe bluetooth");
        printf("[");
        printf(GREEN "Unlock" RESET);
        printf("]: ");
        printf("La connexion Bluetooth a été débloquée.\n");
        printf("Un reboot peut être nécessaire pour réactiver cette fonctionnalité.\n");
      }
      else
      {
        printf("[");
        printf(RED "Failed" RESET);
        printf("]: ");
        printf("Périphérique inconnu.\n");
        return(1);
      }
      break;
    case 'a':
      // Le system suivant est pour éviter des erreurs si aucun blocage n'a été fait au préalable.
      system("touch /etc/modprobe.d/blacklist.conf");
      wifilock = system("grep -q iwlwifi /etc/modprobe.d/blacklist.conf");
      usblock = system("grep -q usb-storage /etc/modprobe.d/blacklist.conf");
      bluetoothlock = system("grep -q bluetooth /etc/modprobe.d/blacklist.conf");
      if (wifilock == 0)
      {
        printf("[");
        printf(GREEN "Lock" RESET);
        printf("]: ");
        printf("Le Wifi est bloqué.\n");
      }
      else
      {
        printf("[");
        printf(GREEN "Unlock" RESET);
        printf("]: ");
        printf("Le Wifi n'est pas bloqué.\n");
      }
      if (usblock == 0)
      {
        printf("[");
        printf(GREEN "Lock" RESET);
        printf("]: ");
        printf("L'USB est bloqué.\n");
      }
      else
      {
        printf("[");
        printf(GREEN "Unlock" RESET);
        printf("]: ");
        printf("L'USB n'est pas bloqué.\n");
      }
      if (bluetoothlock == 0)
      {
        printf("[");
        printf(GREEN "Lock" RESET);
        printf("]: ");
        printf("Le Bluetooth est bloqué.\n");
      }
      else
      {
        printf("[");
        printf(GREEN "Unlock" RESET);
        printf("]: ");
        printf("Le Bluetooth n'est pas bloqué.\n");
      }
      return (0);
      break;

  }
		++argv;
		--argc;
}
	return (0);
}
else
{
        printf("[");
        printf(RED "Denied" RESET);
        printf("] : ");
        int test;
        printf("Seul un utilisateur ayant les droits nécéssaires peut utiliser ce programme.\n\nTentative reportée dans /var/log/security_access.\n");
        test = system("whoami");
        //ecriture dans le fichier /var/log/security_access
        //printf("", test);

return (0);
}
}
