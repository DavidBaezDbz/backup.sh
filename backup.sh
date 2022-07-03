#! /bin/bash
if [ "$1" == "Debug" ] ; then set -x ; fi
clear
RC=0
# Colores
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"
trap ctrl_c INT
# Funciones Basicos
function ctrl_c(){
	echo -e "\n\n${yellowColour}[*]${endColour}${grayColour} Exit ${greenColour}${0}${grayColour}...\n${endColour}${blueColour}(Ctrl+C)${endColour}"
	exit 1
}
function bannerDBZ(){
	echo -e "\n${redColour}'||''|.                     ||       '||  '||''|.                           '||''|.   '||''|.   |'''''||  "
        sleep 0.05
        echo -e " ||   ||   ....   .... ... ...     .. ||   ||   ||   ....     ....  ......   ||   ||   ||   ||      .|'   "
        sleep 0.05
        echo -e " ||    || '' .||   '|.  |   ||   .'  '||   ||'''|.  '' .||  .|...|| '  .|'   ||    ||  ||'''|.     ||     "
        sleep 0.05
        echo -e " ||    || .|' ||    '|.|    ||   |.   ||   ||    || .|' ||  ||       .|'     ||    ||  ||    ||  .|'     ${endColour}${yellowColour}(${endColour}${grayColour}Create for ${endColour}${redColour} DBZ - ${endColour}${purpleColour} Scrip to generate Bck ${endColour}${yellowColour})${endColour}${redColour}"
        sleep 0.05
        echo -e ".||...|'  '|..'|'    '|    .||.  '|..'||. .||...|'  '|..'|'  '|...' ||....| .||...|'  .||...|'  ||......| ${endColour}\n\n"
        sleep 0.05
}
function banner(){
        echo "+------------------------------------------+"
        printf "| %-40s |\n" "`date`"
        echo "|                                          |"
        printf "|`tput setab 2``tput setaf 0` %-40s `tput sgr0`|\n" "$@"
        echo -e "+------------------------------------------+\n\n"
}
function verifica_si_existe_archivo(){
        if [[ -e  $1 ]]
        then
                        #echo -e "\n\tSe encuntra :${yellowColour}'$1'.${endColour}"
                        #echo -e "\t${purpleColour}[*]${endColour} ${yellowColour}'$1'.${endColour}${greenColour} --> El archivo de copia ya existe. Se va a adiconar el archvivo ${yellowColour}'$1'.${endColour} ${greenColour}al archivo existenete. ${endColour}"
                if [[ -d $1  ]]
                then
                        echo -e "\t${purpleColour}[*]${endColour} ${yellowColour}'$1'.${endColour}${greenColour} --> It is a valid Directory. ${endColour}"
                        RC=0      
                else    
                        if [[ $2 == "UBICACION" || $2 == "BACKUP" ]]
                        then
                                echo -e "\t${purpleColour}[*]${endColour} ${yellowColour}'$1'.${endColour}${greenColour} --> It is a valid file. ${endColour}"
                        fi
                        # Para la ubicacion necesito que sea un directorio
                        if [[ $2 == "UBICACION" ]]
                        then
                                RC=1
                        else
                                RC=0
                        fi
                        if [[ $2 == "7z" || $2 == "Tar" ]]
                        then
                                RC=0
                                echo -e "\t${purpleColour}[*]${endColour} ${yellowColour}'$1'.${endColour}${greenColour} \n\t\t--> The copy file already exists. The file will be added. ${yellowColour}'$1'.${endColour} ${greenColour}to the existing file.. ${endColour}"
                        fi 
                fi
                #if [[ -w $1 ]]
                #then
                #        echo "El archivo :' $1 ' tiene permisos de escritura."
                #fi
                if [[ $2 == "UBICACION" || $2 == "BACKUP" ]]
                then
                        if [[ -r $1 ]]
                        then
                                echo -e "\t${purpleColour}[*]${endColour} ${yellowColour}'$1'.${endColour}${greenColour} --> Has read permissions. ${endColour}"
                                if [[ $RC -eq 1 ]]; then  RC=1; else RC=0 ; fi
                        fi
                        #if [[ -x $1 ]]
                        #then
                        #        echo -e "El archivo :' $1 ' ${blueColour}tiene permisos de ejecucion.${endColour}"
                        #fi
                        if [[ -s $1 ]]
                        then
                                echo -e "\t${purpleColour}[*]${endColour} ${yellowColour}'$1'.${endColour}${greenColour} --> The size is $(stat -c%s "$1") Bytes. ${endColour}" 
                                if [[ $RC -eq 1 ]]; then  RC=1; else RC=0 ; fi
                        fi
                fi
        else        
                if [[ $2 == "UBICACION" || $2 == "BACKUP" ]]
                then
                        echo -e "\n\t${purpleColour}[*]${endColour}${yellowColour} '$1'.${endColour}${redColour} --> The directory or file entered is not found. ${endColour}" 
                        RC=1
                fi
        fi
}
function comprimir_tar(){
        ###tar -cvpzf $dest/$archive_file $backup_files #c – compression #v – verbose #p – retain file permissions #z – create gzip file #f – regular file
        if [[ -e $1 ]]
        then
                OPERACION=Tar
                echo -e "\n${blueColour}Compressing Tar ${endColour}${yellowColour}'$1'.${endColour} en ${yellowColour}'$2'.${endColour}"
                verifica_si_existe_archivo $2 $OPERACION
                tar -cvpzf $2 $1
                RC=$?
                if [[ $RC -eq 0 ]]
                then
                        echo -e "\n${blueColour}Compressed file ${greenColour}'$2'.${endColour}"
                else
                        echo -e "\n${redColour}Error when compressing '$2'.${endColour}"
                fi
        else
                echo -e "\n${blueColour}File not found ${endColour}${redColour}'$1'.${endColour}"
        fi
}
function comprimit_7z(){
        if [[ -e $1 ]]
        then
                OPERACION=7z
                echo -e "\n${blueColour}Compressed 7z ${endColour}${yellowColour}'$1'.${endColour} en ${yellowColour}'$2'.${endColour}"
                verifica_si_existe_archivo $2 $OPERACION
                7z a $2 $1
                RC=$?
                if [[ $RC -eq 0 ]]
                then
                        echo -e "\n${blueColour}Compressed file ${endColour}${greenColour}'$2'.${endColour}"
                else
                        echo -e "\n${redColour}Error when compressing ${endColour}${redColour}'$2'.${endColour}"
                fi
        else
                echo -e "\n${blueColour}File not found ${endColour} ${redColour}'$1'.${endColour}"
        fi
}
function valido_estado(){
        if [[ $1 -eq 1 ]]
        then
                echo -e "\n\t${purpleColour}[*]${endColour} ${greenColour}The current status of the transaction is: ${endColour}${redColour}'$1'.${endColour}\n\t\t${purpleColour}[--]${endColour} ${redColour}THE PROCESS IS STOPPED...${endColour}"
                exit 1      
        #else
        #        echo -e "\n\t${purpleColour}[*]${endColour} ${greenColour}El estado actual de la transacion es: ${endColour}${greenColour}'$1'.${endColour}\n\t\t${purpleColour}[--]${endColour} ${turquoiseColour}SE PUEDE PROSEGUIR CON EL PROCESO...${endColour}"
        fi
}

# Inicio de la pantalla
clear
bannerDBZ
banner "Backup System"
# Variable de sesion
RC=0

OPERACION=BACKUP
# Ubicacion de lo que se quiere copiar
echo -e "\n${yellowColour}Backup Information\n${endColour}${grayColour}Write the route(s) (${greenColour}Ex: /home /var/spool/mail /etc /root /boot /opt ${endColour}) to which you want to generate a backup copy.${endColour}"
read -e -p "Copy of : " backup_files
if [[ ${#backup_files} -eq 0 ]]
then 
        echo -e "\n\t${redColour}No path has been entered to generate the backup copy.${endColour}" 
        RC=1 
        valido_estado $RC 
fi
verifica_si_existe_archivo $backup_files $OPERACION
valido_estado $RC
#backup_files="/home /var/spool/mail /etc /root /boot /opt"

OPERACION=UBICACION
# Ubicaciond e la copia de segurida
echo -e "\n${yellowColour}Backup Location\n${endColour}${grayColour}Write the route (${greenColour}Ex: /mnt/backup${endColour}) where you want to store the backup.${endColour}" 
read -e -p "Ubicacion de la Copia : " dest
if [[ ${#dest} -eq 0 ]]
then 
        echo -e "\n\t${redColour}No path has been entered to locate the backup.${endColour}" 
        RC=1 
        valido_estado $RC 
fi
verifica_si_existe_archivo $dest $OPERACION
valido_estado $RC
#dest="/mnt/backup"

# Crear el nombre del archvico con estacion y fecha
day=$(date +'%A-%b-%d-%y')
hostname=$(hostname -s)
archive_file="$hostname-$day.tgz"

# Tiempo cuando empieza la copia.
echo -e "\nStart backup of ${blueColour}$backup_files${endColour} to the archive ${greenColour} $dest$archive_file${endColour}"
echo -e "\t${turquoiseColour}$(date)${endColour}"

# Verificar como desea comprimir si por 7z o tar.
echo -e "\nHow do you want to compress the backup copy?? ${yellowColour}(tar(1)/7z(2))${endColour}"
read -p ": " opcion
case $opcion in
        tar|1)
                archive_file="$archive_file.tgz"
                comprimir_tar $backup_files $dest$archive_file
                valido_estado $RC
                ;;
        7z|2)
                archive_file="$archive_file.7z"
                comprimit_7z $backup_files $dest$archive_file
                valido_estado $RC
                ;;
        *)
                echo -e "\n${redColour}Invalid option.${endColour}"
                RC=1
                valido_estado $RC
                ;;
esac

# Tiempo cuando termina la copia
echo -e "\Finished Backup ${blueColour}$backup_files${endColour} to the archive ${greenColour} $dest$archive_file${endColour}"
echo -e "\t${greenColour}$(date)${endColour}\n"

# Verificar el archivo resultante de la copia de seguridad.

echo -e "\nFile created ${blueColour}$backup_files${endColour} to the archive  ${greenColour} $dest$archive_file$ {endColour}"
echo -e "\n${blueColour}ls -lh $dest$archive_file${endColour}\n"
ls -lh $dest$archive_file
#Esta vacio por las pruebas
#ls -lh $dest
exit 0
