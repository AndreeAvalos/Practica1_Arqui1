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

PUTC    MACRO   char
    PUSH AX
	MOV AL, char
	MOV AH, 0Eh
    INT 10h     
    POP AX
ENDM  

print MACRO msg 
    push ax
    push dx
    mov ah,09h
    mov dx,offset msg
    int 21H
    pop dx
    pop ax
ENDM
		
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
msjop db 0Ah,0dh,"Ingrese Operador + - * / : ","$"
msj2 db 0Ah,0dh, "USTED ACABA DE SALIR..... :D","$"
msj3 db 0Ah,0dh,"****Bienvenido a Modo de Carga 	****","$"
msj4 db 0Ah,0dh,"****Bienvenido a Modo Calculadora	****","$"
msj5 db 0Ah,0dh,"****Bienvenido a Modo Factorial 	****","$"
msj6 db 0Ah,0dh,"****Bienvenido a Modo Reporte 		****","$"
msj7 db 0Ah,0dh,"Desea ingresar otra operacion? Si=1/ No=0","$"
msjResultado db 0Ah,0Dh, "Resultado= ", "$"
msj_error db 0ah,0dh,"Valor Fuera de Rango","$"
nuevaLinea	db	0Ah,0Dh, '$'
fac0 db '0!=1','$'
fac1 db '1!=1','$'
fac2 db '2!=1*2=2','$'
fac3 db '3!=1*2*3=6','$'
fac4 db '4!=2*3*4=24 ','$'
fac5 db '5!=2*3*4*5=120 ','$'
fac6 db '6!=2*3*4*5*6=720','$'
fac7 db '7!=2*3*4*5*6*7=5040','$'
err1 db "Operador Equivocado", 0Dh,0Ah , '$'
aprox db "Aproximadamente $"
;----------------------------------------------------------------------------------------------------------------
factorial db 0
opcion db 0 ;variable para almacenar la eleccion del usuario
;-----------------Variables para almacenar valores y operador-----------------
numero1 dw ?
numero2 dw ?
op db '?'
;------------------------------------------------------------------------------
numeroAux db ?
Resultado db ? 

;///////////////////////////////////////////////////
;definimos el area de codigo
.code
;Proceso principal
.startup
	imprimir encabezado
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
			imprimir msj3
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
			
			cmp op,'*'
			je @@Multiplicacion
		
			cmp op,'+'
			je @@Suma

			cmp op,'-'
			je @@Resta
		
			cmp op,'/'
			je @@Division
			
			@@Suma:
			call Suma
			jmp retorno
			
			@@Resta:
			call Resta
			jmp  retorno
			
			@@Multiplicacion:
			call Multiplicacion
			jmp retorno
			
			@@Division:
			call Division
			jmp retorno
			
			
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

			@@OperadorIncorrecto:
				lea dx, err1
				mov ah, 09h                     ; muestra mensaje de error y vuelve a pedir un operador valido
				int 21h
				jmp @calculadora
			jmp Bucle_Menu;retornamos a menu
		@factorial:
			
			jmp Bucle_Menu;retornamos a menu
		@reporte:
			
			jmp Bucle_Menu;retornamos a menu
		@salir:
			mov ah,09h
			lea dx,msj2;mostramos mensaje de salida
			int 21h

			mov ax,4c00h ;Opcion para salir
			int 21h ;Termmina interrupcion 21h funcion DOS
		
	Bucle_Menu endp
;----------------------------Area para procesos--------------------------
;=================Procesos de operaciones==================================
Suma proc near
	mov ax, numero1
	add ax,numero2
	call Imprimir_Numero
	ret
Suma endp

Resta proc near
	mov ax,numero1
	sub ax,numero2
	call Imprimir_Numero
	ret
Resta endp

Multiplicacion proc near
	mov ax,numero1
	imul numero2
	call Imprimir_Numero
	ret
Multiplicacion endp

Division proc near
	mov dx,0000h
	mov ax,numero1
	idiv numero2
	call Imprimir_Numero
	cmp dx,0
	jnz msj_Flotante
	
	ret
Division endp

msj_Flotante proc near
	lea dx, aprox
	mov ah,09h
	int 21h
	ret
msj_Flotante endp

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
;-------------------------------------------------------------------------------
.exit
end 