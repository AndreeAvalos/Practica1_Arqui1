;--------Area de Macros(Metodos)-------
;---Macro para imprimir el mensaje recibido
imprimir macro mensaje
	lea dx,mensaje
	mov ah,09h
	int 21h
	mov ax,@data
	mov ds,ax
	mov es,ax
endm

imprimirCaracter macro char
    PUSH AX;agregamos a pila ax
	MOV AL, char;movemos a al el caracter entrante
	MOV AH, 0Eh;funcion de salida teletipo
    INT 10h; interrupcion con funcion VGA
    POP AX;sacamos de pila ax
endm  

print macro msg 
    push ax
    push dx
    mov ah,09h
    mov dx,offset msg
    int 21H
    pop dx
    pop ax
endm
;-----------------------------------------
.model small;modelo del programador
.stack 200h;reservamos el espacio en memoria de la pila
.data;Definimos las variables para el funcionamiento
;--------------------------------------Espacio para declarar mensajes-----------------------------
;db = define byte dw = define word
;0Ah,0Dh (10,13) = Salto de linea y retorno de carro en hexadecimal
encabezado db 0Ah, 0Dh,"UNIVERSIDAD DE SAN CARLOS DE GUATEMALA",
			  0Ah, 0Dh,"FACULTAD DE INGENIERIA ESCUELA DE CIENCIAS Y SISTEMAS",
			  0Ah, 0Dh,"ARQUITECTURA DE COMPUTADORES Y ENSAMBLADORES 1 B",
			  0Ah, 0Dh,"PRIMER SEMESTRE 2018",
			  0Ah, 0Dh,"Carlos Andree Avalos Soto",
			  0Ah, 0Dh,"201408580",
			  0Ah, 0Dh,"Primera Practica", "$"

menu_principal db 0Ah, 0Dh,"##################################",
				  0Ah, 0Dh,"######### MENU PRINCIPAL #########",
				  0Ah, 0Dh,"##################################", 
				  0Ah, 0Dh,"### 1. Cargar Archivo          ###", 
				  0Ah, 0dh,"### 2. Modo Calculadora        ###", 
				  0Ah, 0dh,"### 3. Factorial               ###", 
				  0Ah, 0Dh,"### 4. Crear Reporte           ###",
				  0Ah, 0Dh,"### 5. Salir                   ###",
				  0Ah, 0Dh,"##################################", "$"
				  
msj1 db 0Ah,0dh,"Ingrese opcion: ","$"
msjNum db 0Ah,0dh,"Ingrese Numero: $"
msjFac db 0Ah,0dh,"Ingrese Factorial: $"
msjop db 0Ah,0dh,"Ingrese Operador + - * / : ","$"
msj2 db 0Ah,0dh, "USTED ACABA DE SALIR..... :D","$"
msj3 db 0Ah,0dh,"****	Bienvenido a Modo de Carga 		****","$"
msj4 db 0Ah,0dh,"****	Bienvenido a Modo Calculadora	****","$"
msj5 db 0Ah,0dh,"****	Bienvenido a Modo Factorial 	****","$"
msj6 db 0Ah,0dh,"****	Bienvenido a Modo Reporte 		****","$"
msj7 db 0Ah,0dh,"Desea ingresar otra operacion? Si=1/No=0","$"
msj9 db 0Ah,0dh,"Desea ingresar otro factorial? Si=1/No=0","$"
msj8 db 0Ah,0dh,"Desea ingresar otra ruta? Si=1/No=0","$"
msj_10 db 0Ah,0dh,"Caracter no valido: ","$"
msj11 db 0Ah,0dh,"Operacion: ","$"
msjResultado db 0Ah,0Dh, "Resultado = ", "$"
msj_error db 0ah,0dh,"Valor Fuera de Rango","$"
msj_Ruta db 0Ah,0Dh, "Ingrese ruta de archivo: ","$"
noAbre db 0ah,0dh,'No se pudo abrir el archivo.','$'
noLee db 0ah,0dh,'No se puede leer el archivo.','$'
noCierra db	0ah,0dh,'No se puede cerrar el archivo.','$'
msgNoExisteA db 0ah,0dh, 'El archivo no existe','$' 
msgErrorA db 0ah,0dh, 'Error al leer el archivo','$' 
msgCargaA db  0ah,0dh, 'El archivo se ha cargado', '$'
msgNoFormato db 'El archivo no tiene el formato','$'  
msgReporte db 'El reporte se ha creado.','$' 
nuevaLinea	db	0Ah,0Dh, '$'
fac0 db  0Dh,0Ah ,'0!=1','$'
fac1 db  0Dh,0Ah ,'1!=1','$'
fac2 db  0Dh,0Ah ,'2!=1*2=2','$'
fac3 db  0Dh,0Ah ,'3!=1*2*3=6','$'
fac4 db  0Dh,0Ah ,'4!=1*2*3*4=24','$'
fac5 db  0Dh,0Ah ,'5!=1*2*3*4*5=120','$'
fac6 db  0Dh,0Ah ,'6!=1*2*3*4*5*6=720','$'
fac7 db  0Dh,0Ah ,'7!=1*2*3*4*5*6*7=5040','$'
err1 db  0Dh,0Ah ,"¡¡¡¡¡¡¡¡¡¡¡¡¡¡Operador Equivocado!!!!!!!!!!!!",  0Dh,0Ah ,'$'
aprox db " Aproximado al entero mas cercano $"
;----------------------------------------------------------------------------------------------------------------
factorial db 0
opcion db 0 ;variable para almacenar la eleccion del usuario
diez dw 10
;-----------------Variables para almacenar valores y operador-----------------
numero1 dw ?
numero2 dw ?
unidades db 0
decenas db 0
numeroAux db 0

ans dw ?
op db '?'
;----------------Variables para cargar archivo ------------------
handle dw ? 
buffArch	db	?
ruta db 60 dup(0) ;Variable que se utiliza para la ruta del archivo  
contenido db 75 dup(0) ;variable para obtener el contenido del archivo
inChar db '?' 
;-----------------------------------------------------------------
;///////////////////////////////////////////////////
;definimos el area de codigo
.code
;Proceso principal
.startup
	imprimir encabezado
	mov ans, 0000h;asignamos el valor 0 a ans
	
	Bucle_Menu proc near
		imprimir menu_principal
		
		call leer_linea;Llamamos al proceso leer linea para optener la opcion
		
		cmp opcion,1; si opcion es igual a 1
		je @cargar; saltamos a modo de carga de archivos
		
		cmp opcion,2;si opcion es igual a 2
		je @calculadora;saltamos a modo calculadora
		
		cmp opcion,3;si opcion es igual a 3
		je @factorial;saltamos a modo factorial
		
		cmp opcion,4;si opcion es igual a 4
		je @reporte;saltamos a modo reporte
		
		cmp opcion,5;si opcion es igual a 5
		je @salir; saltamos a salir
		
		jmp Bucle_Menu;si no es ninguno de los anteriores entonces vuelve a llamarse a si mismo
		
		@cargar:
			imprimir msj3;imprimimos el mensaje de bienvenida
			imprimir msj_Ruta; mensaje de ruta
			mov si,00;limpiamos contador
			@Inicio:;leemos que sea &
				call obtener_char;obtenemos el caracter entrante
				cmp inChar,'&';lo comparamos 
				je @@Inicio;si es igual entonces pasa
				call remover_caracter;de lo contrario lo removemos de la salida en consola
				
				jmp @Inicio
		
				@@Inicio:
					call obtener_char;obtenemos el valor del teclado
					cmp inChar,'&'; lo comparamos
					je @LeerPath; si es igual ya tenemos el && por lo tanto adentro viene la path
					
					call remover_caracter; de lo contrario removemos el caracter entrante y pedimos de nuevo 
					
					jmp @@Inicio
		
			@LeerPath:
				call obtener_char;onntenemos el caracter entrante 
				mov ruta[si],al;lo guardamos en el vector de ruta
				inc si; incrementamos el contador
				cmp inChar,'&';comparamos si viene el signo
				je @Fin; si viene entonces es el inicio para el fin de ruta
				jnz @LeerPath; de lo contrario seguimos pidiendo caracteres

			@Fin:
				call obtener_char; obtenemos caracter
				cmp inChar,'&'; comparamos el &
				je @@Fin;si es asi entonces termina de introducir caracteres 
				call remover_caracter; de lo contrario removemos el caracter
				jmp @Fin
		
				@@Fin:
					call obtener_char; obtenemos el caracter 
					
					cmp inChar,0Dh; si es un intro 
					mov ruta[si-1],"$";agregamos al final $ para que sea imprimible
					je @abrir_archivo;saltamos a abrir archivo
					
					call remover_caracter; removemos caracter de lo contrario
					jmp @@Fin;volvemos a pedir hasta que sea intro
					
			@abrir_archivo:
				clc; limpiar bandera de acarreo
				mov ah,3Dh; funcion para abrir un fichero
				mov al, 0000h;limpiamos registro bajo
				mov dx, offset ruta; pasamos el contenido de ruta a dx
				int 21h;funcion DOS
				print ruta;
				jc @error_abrir; si existe acarreo entonces no se puede abrir el archivo		
				
				
				
				
			@leer:
				mov handle,ax;movemos hacia el puntero
				mov ah,3Fh;lectura de fichero
				mov bx, handle; movemos apuntador hacia bx
				mov cx,75; cantidad de bytes a leer
				lea dx, contenido; donde se almacenaran los bytes leidos
				int 21h;interrupcion DOS
				jc @error_leer;si existe acarreo existe error 
				mov ah,3Eh;cerrar fichero
				mov bx, handle
				int 21h;funcion DOS
				
				mov si,0
				
			@leer_Contenido:
			
				cmp contenido[si],' ';comparamos con espacio para seguir en el archivo
				je @seguir;
				
				cmp contenido[si],'*';comparamos con multiplicacion
				je @Multiplicacion
				
				cmp contenido[si],'+';compramos con suma
				je @Suma
				
				cmp contenido[si],'-';comparamos con resta
				je @Resta
				
				cmp contenido[si],'/';comparacion con division
				je @Division
				
				cmp contenido[si],';';compramos con punto y como 
				je @fin_archivo; vamos a finalizar de leer
				
				cmp contenido[si],'0'; compramos si es nuemero
				jae @esnumero;si es mayor o igual a 0
				
			@esnumero:
				cmp contenido[si],'9';compramos con 9
				jbe @validacion;es valido si es menor o igual a 9
				jne @informarError;de lo contrario es caracter no valido y se informar
				
			@validacion:
				
				mov bx,0;limpiamos los registros bx, ax
				mov ax,0
				
				mov al,contenido[si];copiamos el primer digito
				sub al,'0';extraemos para convertir a decimal
				cbw ;convertimos de byte a palabra
				mov numero1,ax;movemos el registro al auxiliar numero
				inc si;incrementamos el contador
				
				mov al,contenido[si];copiamos el segundo digito
				inc si;incrementamos el contador
				sub al,'0';restamos 30h para convertirlo en decimal
				cbw; convertimos de byte a palabra(word)
				mov numero2,ax;pasamos al registro auxiliar
				
				mov ax,numero1;movemos a dx el primer digito
				mul diez;lo multiplicamos Ax=ax*10
				mov bx,numero2;movemos al registro el segundo digito
				add ax,bx; agreamos las unidades a las decenas para formar el numero
				
				push ax;agregamos a la pila ax

				;call Imprimir_Numero
				
				
				jmp @leer_Contenido
				
			@Multiplicacion:
				pop ax;sacamos el primer valor y se almacena en ax
				pop bx;sacamos el segundo valor y se almacena en bx
				
				imul bx; ax=ax*bx
				push ax; ingresamos nuevamente el valor resultante en la pila
				jmp @seguir
				
			@Suma:
				pop ax;sacamos el primer valor y se almacena en ax
				pop bx;sacamos el segundo valor y se almacena en bx
				
				add ax,bx; 
				push ax; ingresamos nuevamente el valor resultante en la pila
				jmp @seguir
				
			@Resta:
				pop ax;sacamos el primer valor y se almacena en ax
				pop bx;sacamos el segundo valor y se almacena en bx
				
				sub ax,bx; 
				push ax; ingresamos nuevamente el valor resultante en la pila
				jmp @seguir
				
			@Division:
				pop ax;sacamos el primer valor y se almacena en ax
				pop bx;sacamos el segundo valor y se almacena en bx
				
				idiv bx; ax=ax/bx
				push ax; ingresamos nuevamente el valor resultante en la pila
				jmp @seguir
				
			@seguir:
				inc si
				jmp @leer_Contenido
				
			@error_abrir:
				imprimir msgNoExisteA  ; mostramos mensaje de que no existe el archivo
				jmp @Retorno ;vuelve a pedir el path 
				
			@error_leer:
				imprimir msgErrorA ;mensaje de que ahi un error al leer el archivo
				jmp @Retorno ;vuelve a pedir el path 
			
			@informarError:
				imprimir msj_10
				imprimirCaracter contenido[si]
				jmp @seguir
				
			@fin_archivo:
				mov contenido[si+1],"$"
				imprimir msgCargaA
				imprimir msj11
				imprimir contenido
				imprimir msjResultado
				pop ax
				call Imprimir_Numero
				jmp @Retorno
				
			@Retorno:
			;aqui debe ir para hacer operacion
				imprimir msj8
				imprimir msj1
			
				mov ah,01h;leer caracter desde teclado
				int 21h; 
				sub al,30h;restamos 48 en hexadecimal para obtener un numero 
				mov opcion,al;movemos el valor resultante la opcion
				
				cmp opcion,1
				je @cargar
			
				cmp opcion,0
				je Bucle_Menu
				
			jmp Bucle_Menu;retornamos a menu
		@calculadora:
			imprimir msj4;imprimimos mensaje de bienvenida
			imprimir msjNum;imprimimos mensaje para pedir numero
			
			call obtener_numero;llamamos al proceso 
			mov numero1,cx;movemos el resultado a nuestra variable numero1
			
			call obtener_operador		
			
			cmp op,'*';si el numero es menor a * en ascii
			jb @@OperadorIncorrecto;entonces saltamos a proceso
			cmp op,'/';de la misma forma si es mayor en ascii
			ja @@operadorIncorrecto
			
			imprimir msjNum;imprimimos mensaje para pedir numero
			call obtener_numero;llamamos al proceso
			mov numero2,cx;movemos el segundo resultado a numero2
			
			imprimir msjResultado;imprimimos el msj de resultado
			
			;/////////////////////////Tipo Switch//////////////////////
			cmp op,'*' ;comparamos si el caracter es *
			je @@Multiplicacion;vamos al "metodo de multiplicacion
		
			cmp op,'+';comparamos si es suma
			je @@Suma ;saltamos al metodo suma

			cmp op,'-';comparamos si es resta
			je @@Resta;saltamos hacia resta
		
			cmp op,'/';si es division 
			je @@Division;saltamos a division
			;///////////////////// Casos Switch ///////////////////////
			
			@@Suma:
				call Suma;llamamos al proceso suma
				jmp retorno;no dirigimos hacia el retorno
			
			@@Resta:
				call Resta;llamamos al proceso resta
				jmp  retorno;no dirigimos hacia el retorno
			
			@@Multiplicacion:
				call Multiplicacion;llamamos al proceso multiplicacion
				jmp retorno;no dirigimos hacia el retorno
			
			@@Division:
				call Division;llamamos el proceso division
				jmp retorno;no dirigimos hacia el retorno
				
			;////////////////////////////////////////////////////////////
			;-------- Para poder retornar hacia el menu o calculadora
			retorno:
				imprimir msj7
				imprimir msj1

				mov ah,01h;leer caracter desde teclado
				int 21h; 
				sub al,30h;restamos 48 en hexadecimal para obtener un numero 
				mov opcion,al;movemos el valor resultante la opcion
		
		
				cmp opcion,1
				je @calculadora
		
				cmp opcion,0
				je Bucle_Menu
			;Si existe un error al ingresar el operador
			@@OperadorIncorrecto:
				lea dx, err1 ;mostramos el msj
				mov ah, 09h; agregamos funcion 
				int 21h;mostramos en DOS
				jmp @calculadora; regresa al inicio de calculadora
			
			jmp Bucle_Menu;retornamos a menu
		@factorial:
			imprimir msj5;imprimimos msj de bienvenida
			imprimir msjFac;pedimos factorial
			
			call obtener_numero;obtenemos el numero
			mov numero1,cx; lo guardamos en la vaariable numero1
			
			cmp numero1,7;comparamos el valor que entra
			jle @@validacion;si es menor o igual a 7 saltamos a validacion
			jg mostrar_error;de lo contrario desplegamos mensaje de error
			
			@@validacion:
				cmp numero1,0;comparamos valor con 0
				jge @@ejecutarFactorial;si el valor es mayor o igual a 0
				jl mostrar_error; de lo contrario mostramos error
				
			@@ejecutarFactorial:
				mov si,0000h;limpiamos registro si
				cmp numero1,0;compramos si es 0 el valor
				je @@@es_cero;si es exactamente 0 saltamos a cero
				inc si;incrementamos el valor de si
				jg @@@bucleFactorial;si es mayor a 0 entonces entramos al bucle
			
				@@@es_cero:
					imprimir fac0;imprimimos mensaje de factorial
					imprimir msjResultado;mostramos resultado
					imprimirCaracter '1';imprimimos 1
				
					jmp @@retorno;saltamos a retorno 
			
				@@@bucleFactorial:
					cmp si,numero1;comparamos que si sea menor o igual a numero1
					jg @@@calcular_factorial;si es mayor entonces salta a calcular su factorial
				
					cmp si,1
					je @@@fac1;si es igual a 1 imprime
				
					cmp si,2
					je @@@fac2;si es igual a 2 imprime
				
					cmp si,3
					je @@@fac3;si es igual a 3 imprime
				
					cmp si,4
					je @@@fac4;si es igual a 4 imprime
				
					cmp si,5
					je @@@fac5;si es igual a 5 imprime
				
					cmp si,6
					je @@@fac6;si es igual a 6 imprime
				
					cmp si,7
					je @@@fac7;si es igual a 7 imprime
				
				
					@@@fac1:
						imprimir fac0;imprimimos factorial
						imprimir fac1;imprimimos factorial
						inc si;incrementamos el si 
						jmp @@@bucleFactorial;regresamos al bucle
					@@@fac2:
						imprimir fac2;imprimimos el factorial
						inc si;incrementamos el si 
						jmp @@@bucleFactorial;regresamos al bucle
					@@@fac3:
						imprimir fac3
						inc si
						jmp @@@bucleFactorial
					@@@fac4:
						imprimir fac4
						inc si
						jmp @@@bucleFactorial
					@@@fac5:			
						imprimir fac5
						inc si
						jmp @@@bucleFactorial
					@@@fac6:
						imprimir fac6
						inc si
						jmp @@@bucleFactorial
					@@@fac7:
						imprimir fac7
						inc si
						jmp @@@bucleFactorial
					
					@@@calcular_factorial:
						imprimir msjResultado;imprimimos el msj resultado 
						call CalcularFactorial;calculamos el factorial
						jmp @@retorno;retornamos
			
			@@retorno:
				imprimir msj9
				imprimir msj1

				mov ah,01h;leer caracter desde teclado
				int 21h; 
				sub al,30h;restamos 48 en hexadecimal para obtener un numero 
				mov opcion,al;movemos el valor resultante la opcion
		
		
				cmp opcion,1
				je @factorial
		
				cmp opcion,0
				je Bucle_Menu
			
			
			
			jmp Bucle_Menu;retornamos a menu
		@reporte:
			imprimir msj6
			jmp Bucle_Menu;retornamos a menu
			
		@salir:
			mov ah,09h
			lea dx,msj2;mostramos mensaje de salida
			int 21h

			mov ax,4c00h ;Opcion para salir
			int 21h ;Termmina interrupcion 21h funcion DOS
		
	Bucle_Menu endp
;----------------------------Area para procesos--------------------------
;============================Proceso para leer archivo=====================
remover_caracter proc near
	imprimirCaracter 08h;eliminamos la posicion anterior 
	imprimirCaracter ' ';limpiamos la posicion actual
	imprimirCaracter 08h 
	ret	
remover_caracter endp
;==========================================================================

;=================Procesos de operaciones==================================
Suma proc near
	mov ax, numero1;movemos el numero hacia el registro ax
	add ax,numero2;sumamos el numero 2 con el mismo registro
	mov ans,ax;movemos el resultado a ans
	call Imprimir_Numero;llamamos al proceso
	ret;retornamos
Suma endp

Resta proc near
	mov ax,numero1;movemos el numero hacia el registro ax
	sub ax,numero2;restamos el numero 2 a ax
	mov ans,ax;movemos el resultado a ans
	call Imprimir_Numero;llamamos al proceso para imprimir numeros
	ret;retornamos
Resta endp

Multiplicacion proc near
	mov ax,numero1;movemos el numero a el registro ax
	imul numero2; multiplicamos AX=AX*numero2
	mov ans,ax;movemos el resultado a ans
	call Imprimir_Numero;llamamos al proceso para imprimir un numero
	ret;retornamos 
Multiplicacion endp

Division proc near
	mov dx,0000h;limpiamos el registro dx
	mov ax,numero1; movemos el numero hacia el registro ax
	idiv numero2;dividimos AX=AX/numero2.... Al=consciente Ah=residuo
	mov ans,ax;movemos el resultado a ans
	call Imprimir_Numero;llamamos el proceso para imprimir numero
	cmp dx,0;si dx tiene residuo 
	jnz msj_Flotante; saltamos hacia el proceso de flotante
	
	ret; retornamos
Division endp

msj_Flotante proc near
	lea dx, aprox;cargamos el mensaje
	mov ah,09h
	int 21h; interrupcion DOS
	ret;retornamos
msj_Flotante endp

;==========================================================================

;=============Proceso para Calcular el Factorial de un numero==============
CalcularFactorial proc near
	mov cx,numero1
	mov ax,01
	
	@inicio:
		mul cx
		dec cx
		jz @fin
		jmp @inicio
	@fin:
		push dx
		push cx
		push bx
		push ax
		mov cx,0000h
		mov bx,10
		@@bucle1:        
			mov dx,0
			div bx
			push dx
			inc cx
			or ax,ax
			jnz @@bucle1
		@@bucle2:
			pop dx
			add dl,30H
			mov ah,02H
			int 21H
			loop @@bucle2
			pop ax
			pop bx
			pop cx
			pop dx
			ret
	
CalcularFactorial endp
;==========================================================================
;=================Proceso para Leer un numero==============================
obtener_numero proc near
	
	push dx;metemos el pila el registro dx
	push ax;metemos en pila el registro ax
	push si;metemos en pila el registro indice (si)
	
	mov cx,0000h;limpiamos el registro
	mov cs:negativo,0;reseteamos bandera negativo
	
	@siguiente_digito:
		mov ah,00h;lee la pulsacion de tecla
		int 16h;obtener pulsaciones de teclado
		
		mov ah,0Eh;Salida de teletipo
		int 10h;interrupcion con funciones vga
		
		cmp al,'-';comparamos si el signo que entra es -
		je @asignar_negativo;nos movemos hacia el proceso
		
		cmp al,'a';comparamos si es ans 
		je @asignar_anterior;nos movemos para asignar el valor anterior
		
		cmp al,0Dh;si el caracter entrante es salto de linea
		jne @sin_carrie;si no es 0 
		
		jmp @parar_entrada;nos movemos al proceso final
	
	@asignar_anterior:
		mov cx,ans
		jmp @parar_entrada
	
	@sin_carrie:
		cmp al,08h;comprobamos si se presiona el retroceso 
		jne @verificacion;saltamos hacia su verificacion
		mov dx,0000h;limpiamos el registro dx
		mov ax,cx;movemos de registros 
		div diez; dividimos ax=ax/10
		mov cx,ax;volvemos a mover el registro
		imprimirCaracter ' ';limpiamos la posicion
		imprimirCaracter 08h;retorno para regresar a la misma posicion
		
		jmp @siguiente_digito; saltamos al inicio
		
	@verificacion:
		cmp al,'0';comparacion 
		jae @entrecero_nueve; si es mayor o igual a 0 el caracter
		jmp @remover_caracter;de lo contrario 
		
	@entrecero_nueve:
		cmp al,'9';comparacion
		jbe @esnumero; si el numero es menor o igual a 9 salta al proceso
		;en este punto se verifico que el caracter este entre 30h a 39h en ascii
		;0-9 en decimal
	@remover_caracter:
		imprimirCaracter 08h;eliminamos la posicion anterior 
		imprimirCaracter ' ';limpiamos la posicion actual
		imprimirCaracter 08h
		jmp @siguiente_digito;regresamos a introducir un digito
		
	@esnumero:
		push ax;agregamos a la pila el registro
		mov ax,cx;movemos entre registros
		mul diez;multiplicamos ax=ax*10
		mov cx,ax;movemos de nuevo el registro a cx
		pop ax;sacamos el registro ax de la pila 
		
		cmp dx,0; comparamos 
		jne @demasiado_grande; si es diferente a 0
		
		sub al,30h; restamos 48 (30h) para volverlo decimal
		
		mov ah,00h;limpiamos el registro ah
		mov dx,cx;movemos los registros
		add cx,ax; le sumamos a cx el valor de ax
		jc @demasiado_grande2;si existe acarreo en la suma saltamos 
		
		jmp @siguiente_digito;si todo bien regresamos 
		
	@asignar_negativo:
		mov cs:negativo,1;hacemos la bandera que sea positiva
		jmp @siguiente_digito;vamos al siguiente digito
	
	@demasiado_grande:
		mov ax,cx;movemos registros
		div diez; ax=Ax/10
		mov cx,ax;movemos registros
		imprimirCaracter 08h;retrocedemos al espacio anterior
		imprimirCaracter ' ';lo limpiamos 
		imprimirCaracter 08h;regresamos al espacio anterior
		jmp @siguiente_digito; saltamos hacia el siguiente digito
		
	@demasiado_grande2:
		mov cx,dx;movemos registros
		mov dx,0000h;limpiamos dx
	
	@parar_entrada:
		cmp cs:negativo,0;comparamos el estado de la bandera
		je @positivo;si esta en 0 entonces es un numero positivo 
		neg cx ; le hace complemento a 2 a ax
	@positivo:
		pop si;sacamos de la pila el registro de indice 
		pop ax;sacamos de la pila el registro ax
		pop dx;sacamos de la pila el registro dx
		ret;retornamos
	negativo db ?;declaracion de bandera si es negativa o no
obtener_numero endp

;==========================================================================

;Proceso que muestra el numero que se almacena en el registro Ax
;================Proceso para imprimir numero==============================
Imprimir_Numero proc near
	push dx;agregamos a pila dx
	push ax;agregamos a pila ax
	
	cmp ax,0;comparamos ax si tiene algun numero
	jnz @no_cero;si no es cero saltamos
	
	imprimirCaracter '0';mandamos un cero si es 0
	jmp @impreso;saltamos al proceso de finalizacion
	
	@no_cero:
		cmp ax,0;comparamos ax
		jns @positivo; si no tiene signo
		neg ax;complemento a 2
		
		imprimirCaracter '-';agregamos el caracter -
		
	@positivo:
		call Imprimir_Numero_sinSigno;llamamos al proceso para imprimir numeros sin signo
		
	@impreso:
		pop ax;sacamos de pila el registro ax
		pop dx;sacamos de pila el registro dx
		ret;retornamos
Imprimir_Numero endp
;==========================================================================

;Muestra numero alojados en ax sin signo
;==============Proceso para imprimir un numero sin signo ==================
Imprimir_Numero_sinSigno proc near
	push ax;agregamos a pila ax
	push bx;agregamos a pila bx
	push cx;agregamos a pila cx
	push dx;agregamos a pila dx
	
	mov cx,1
	mov bx,10000
	
	cmp ax,0 ;comparamos el registro ax
	jz @imprimir_cero; si ax es igual a 0 vamos a imprimir 0
	
	@inicio:
		cmp bx,0;comparamos el registro bx
		jz @final;si es igual a 0 saltamos al final
		
		cmp cx,0;comparamos el registro cx
		je @calc;si es igual a 0 saltamos a calc
		
		cmp ax,bx;comparamos ax con bx
		jb @salto;entonces ax<bx por lo tanto div sera diferente cero
	
	@calc:
		mov cx,0000h;limpiamos el registro cx
		mov dx,0000h;limpiamos el registro dx
		div bx;dividimos ax=ax/bx
		add al,30h;lo convertimos en numero ascii
		imprimirCaracter al;lo mandamos a imprimir 
		
		mov ax,dx; guardamos el resultado de la ultima division
		
	@salto:
		push ax
		mov dx,0000h;limpiamos registro
		mov ax,bx;guardamos valor de bx en ax para operar
		div diez;dividimos ax=ax/10
		mov bx,ax
		pop ax
		
		jmp @inicio;regresamos
		
	@imprimir_cero:
		imprimirCaracter '0';imprimimos 0
	
	@final:
		pop dx;sacamos de pila ax,bx,dx,cx
		pop cx
		pop bx
		pop ax
		ret;retornamos
Imprimir_Numero_sinSigno endp
;==========================================================================

;===============Proceso para leer la opcion========================
leer_linea proc near

	mov ah,09h; funcion para imprimir cadena
	lea dx,nuevaLinea;le damos enter
	int 21h; funcion DOS

	mov ah,09h; funcion para imprimir cadena
	lea dx,msj1;para que elija una opcion
	int 21h; funcion DOS

	mov ah,01h;leer caracter desde teclado
	int 21h;interrupcion DOS
	sub al,30h;restamos en codigo ascii para que quede saolamente el numero
	mov opcion, al;movemos el valor resultante la opcion

	ret; para retornar al proceso de donde se llamo 
leer_linea endp
;===================================================================

;=====================Proceso para obtener el operador==============
obtener_operador proc near
	mov ah,09h; funcion para imprimir cadena
	lea dx,msjop;para que elija una opcion
	int 21h; funcion DOS

	mov ah,01h;leer caracter desde teclado
	int 21h
	mov op,al
	
	ret
obtener_operador endp
;====================================================================
;=====================Proceso para obtener el caracter==============
obtener_char proc near
	mov ah,01h;leer caracter desde teclado
	int 21h
	mov inChar,al
	cmp inChar,08h
	jne @todoOk
	je @removercaracter;
	
	@removercaracter:
		imprimirCaracter ' '
		imprimirCaracter 08h
		mov ruta[si],0
		ret
	@todoOk:
		ret
	
obtener_char endp
;====================================================================

;============Proceso para mostrar error==============================
mostrar_error proc near
	imprimir msj_error	
	call Bucle_Menu
mostrar_error endp
;=====================================================================
;-------------------------------------------------------------------------------
.exit
end 