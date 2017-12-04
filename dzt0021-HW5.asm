;; Author: Tran, Donald							 ;;
;;									 ;;
;; Username: DZT0021		  					 ;;
;;									 ;;
;; Homework #5  							 ;;
;;									 ;; 
;; Note: This project performs encrytion and decryption using        	 ;;
;;	 the Vigenere cipher and assumes the plain text and key	 	 ;;
;;	 alphabet consists of all upper case values. Final	 	 ;;
;;       decrpytion text is stored in "det[]"				 ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

.386
.model flat, stdcall
.stack 4096

ExitProcess proto, dwExitCode:dword

.data
	; Mandatory Assignment Values
	pt byte "THENIGHTISDARKANDFULLOFMANYTERRORS"	; Plaintext
	ct byte lengthof pt dup(?)			; Cyphertext
	key byte "GAMEOFTHRONES"			; Key
	
	; Helper Variables
	ket byte lengthof pt dup(?)		; Full Key Text
	det byte lengthof pt dup(?)		; Decrypted Text

.code
	main proc
		call KeyFill
		call Encrypt
		call Decrypt	
		invoke ExitProcess, 0
	main endp

		;;;;;;;;;;;;;;;;;;;;;;;;;; Creates Full Keytext (Procedure);;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		;;											;;
		;; The wrap-around effect is predicated on the fact "ket" (Full Key Text)    		;;
		;; is declared after "key" because the nth-index + 1 of key is the 0th index of "ket"	;;
		;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		KeyFill proc USES esi ebx
			mov esi, 0
			mov ecx, lengthof pt
			
			L:
				mov bl, key[esi]
				mov ket[esi], bl
				inc esi
				dec ecx
				cmp ecx, 0
				je Stop
				jmp L
				Stop:			
			ret
		KeyFill endp

		;;;;;;;;;;;;;;;;;;;; Encryption Procedure ;;;;;;;;;;;;;;;;;;;;;;;;;
		;; Algorithm:							 ;;
		;;	for (int i = 0; i < pt.length(); ++i) {			 ;;
		;;		char c = pt[i];					 ;;
        	;;		ct[i] = (c + ket[i] - 2*'A') % 26 + 'A';	 ;;
        	;;	}							 ;;
		;;								 ;;
		;; Output: Cyphertext is stored in "ct"				 ;;
		;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		Encrypt proc USES edx ebx esi edi
			mov ecx, lengthof pt
			mov esi, 0
			mov edi, 0
			mov ebx, 0
			
			L: 
				mov dx, 0
				movzx ax, ket[esi]
				movzx di, pt[esi]
				add ax, di
				sub ax, (2 * 'A')
				mov bx, 26
				div bx
				add dx, 'A'
				mov ct[esi], dl
				dec ecx
				inc esi
				cmp ecx, 0
				je Stop
				jmp L
				Stop:
			ret
		Encrypt endp
		
		;;;;;;;;;;;;;;;;;;;; Decryption Procedure ;;;;;;;;;;;;;;;;;;;;;;;;;
		;; Algorithm:							 ;;
		;;	for (int i = 0; i < pt.length(); ++i) {			 ;;
		;;		char c = ct[i];					 ;;
        	;;		det[i] = (c - ket[i] + 26) % 26 + 'A';		 ;;
        	;;	}							 ;;
		;;								 ;;
		;; Output: Decryption text is stored in "det"			 ;;
		;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		Decrypt proc USES edx ebx esi edi
			mov ecx, lengthof pt
			mov esi, 0
			mov edi, 0
			mov ebx, 0
			
			L: 
				mov dx, 0
				movzx ax, ct[esi]
				movzx di, ket[esi]
				sub ax, di
				add ax, 26
				mov bx, 26
				div bx
				add dx, 'A'
				mov det[esi], dl
				dec ecx
				inc esi
				cmp ecx, 0
				je Stop
				jmp L
				Stop:
			ret
		Decrypt endp

end main		
