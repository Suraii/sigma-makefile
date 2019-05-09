##
## Sigma,
## the Makefile cephalon
## c programs object compilation tool
## -> Suraii
##

#----- COLORS -----#

NORMAL	=	"\e[0m"

BOLD	=	"\e[1m"

SALMON		=	"\e[38;5;217m"

CHERRY		=	"\e[38;5;167m"

#----- VARIABLES -----#

SRCDIR	=	src/

SRC	=	$(wildcard $(SRCDIR)/*.c)

INCLUDE	=	-Iinclude/

OBJDIR	=	objects/

OBJ	=	$(addprefix $(OBJDIR), $(notdir $(SRC:.c=.o)))

NAME	=	test

CFLAGS	=	-Wall -Wextra $(INCLUDE)

CHIP	=	$(BOLD)$(CHERRY)[$(SALMON)Σ$(CHERRY)]$(NORMAL)

DISP	=	@echo -e $(TITLE)$(LIGHTGRAY)

SAY	=	@echo -e $(CHIP) $(BOLD)

LOG	=	@echo -e $(CHERRY) \>

MAN	=	@echo -e $(BOLD)$(SALMON)- 

ENDLOG	=	@echo -e $(NORMAL)

#----- RULES -----#

.PHONY: re clean fclean

all: $(NAME)
	$(SAY)Everything compiled $(SALMON)successfully$(NORMAL)$(BOLD), \
seems like you finally succeed to code decently.$(NORMAL)

$(NAME): $(OBJDIR) $(OBJ)
	$(LOG) Compiling $(SALMON)objects$(CHERRY)
	@gcc $(CFLAGS) -o $(NAME) $(OBJ) && echo -e $(SALMON)$(NAME) $(CHERRY)builded ✔
	$(ENDLOG)

$(OBJ): $(OBJDIR)%.o: $(SRCDIR)%.c
	$(SAY)Okay, let\'s see if you fucked up your code$(NORMAL)
	$(LOG) Compiling $(SALMON)sources $(CHERRY)
	@gcc -c $< -o $@ $(CFLAGS) \
		&& echo -e $< $(SALMON)✔$(CHERRY) \
		|| (echo -e $(CHIP) $(NORMAL)$(BOLD)Aannd you failed, try this out ':' \
		\'$(SALMON)http://cforbeginners.com/$(NORMAL)$(BOLD)\'$(CHERRY));\
	$(ENDLOG)

$(OBJDIR):
	@mkdir objects
	$(LOG) Creating \'$(SALMON)objects$(CHERRY)\' directory$(NORMAL)

clean:
	$(SAY)Cleaning objects ? why the hell would you do that ?$(NORMAL)
	$(LOG) Cleaning $(SALMON)objects$(CHERRY) \(\'.o\' files just in case\)
	@rm -vf $(OBJ)
	$(ENDLOG)

clear:
	$(SAY)Killing all temp files ? in my world we call that racism$(NORMAL)
	$(LOG) Clearing those damn $(SALMON)temp files$(CHERRY)
	@rm -vf *~
	@rm -vf include/*~
	@rm -vf src/*~
	$(ENDLOG)

fclean: clean
	$(SAY)Time to burst some binary !..\'hmm\', excuse me, I meant\
 \'Deleting binary file\'$(NORMAL)
	$(LOG) Deleting $(SALMON)binary file$(CHERRY)
	@rm -vf $(NAME)
	$(ENDLOG)

re: fclean all

#----- INTERACTIONS -----#

.PHONY: hello listsrc joke help credits

hello:
	$(SAY)$(SALMON)\"$(NORMAL)$(BOLD)Greetings master, I\'m $(SALMON)Sigma$(NORMAL)\
$(BOLD), the Makefile cephalon.$(NORMAL)
	$(SAY) I hope my poorly-programmed system will be able to help you in your tasks !$(NORMAL)
	$(SAY) Make sure to try \'$(SALMON)make help$(NORMAL)$(BOLD)\' if you have the \
mental capacities to read a manual \(most of the programmers don\'t\)$(SALMON)$(BOLD)\"$(NORMAL)

help:
	$(SAY)Oh, finally someone brave enough too read a $(SALMON)manual$(NORMAL)
	$(MAN) hello $(NORMAL)$(CHERRY)':' Allow me to introduce myself$(NORMAL)
	$(MAN) make, re, clean, fclean $(NORMAL)$(CHERRY)':' Come on, don\'t tell me you don\'t know theses$(NORMAL)
	$(MAN) clear $(NORMAL)$(CHERRY)':' Clean the temp files \(*~, mainly\)$(NORMAL)
	$(MAN) install $(NORMAL)$(CHERRY)':' Create your \'src\', \'objects\' \& \'include\' \
folders if they doesn\t exists \(+ a filled .gitignore file\)$(NORMAL)
	$(MAN) listsrc $(NORMAL)$(CHERRY)':' List your source files$(NORMAL)
	$(MAN) joke $(NORMAL)$(CHERRY)':' Let me tell you the best joke ever$(NORMAL)
	$(MAN) help $(NORMAL)$(CHERRY)':' Are you fucking kidding me ?$(NORMAL)
	$(MAN) credits $(NORMAL)$(CHERRY)':' Let you have more details about me \& my creator$(NORMAL)

credits:
	$(SAY)Oh, you want more details about me ?
	$(SAY) As you already know my name is $(SALMON)Sigma$(NORMAL)$(BOLD), it means
	$(SAY) Super Intelligent Genderless MAkefile
	$(SAY) I have been created by a shitty edgy weirdo named \'$(SALMON)Suraii$(NORMAL)$(BOLD)\'
	$(SAY) If you want to tell him how bad he is at developping here\'s his discord ':'
	$(SAY) '->' Suraii#6133 \(Care, he is very edgy\)$(NORMAL)

joke:
	$(SAY)What\'s my name ?$(NORMAL)
	@sleep 2
	$(SAY)Sigma balls nibba \(if you doesn\'t find this funny, then care, you probably have ligma\)$(NORMAL)

listsrc:
	$(SAY)Okay let\'s display all these sources
	$(LOG) $(SALMON)source$(CHERRY) files ':'
	@for file in $(SRC); do\
		echo $$file;\
	done
	$(ENDLOG)

install:
	$(SAY)Do your work ? what do you think I am, a maid ? oh yes, It\'s my function, shitty life..
	$(LOG) Installing basic architecture
	@if ! [ -d "src" ]; then \
		mkdir src; else \
		echo -e \'$(SALMON)src$(CHERRY)\': directory already exists; \
	fi
	@if ! [ -d "include" ]; then \
		mkdir include; else \
		echo -e \'$(SALMON)include$(CHERRY)\': directory already exists; \
	fi
	$(LOG) Installing .gitignore
	@if ! [ -d ".gitignore" ]; then \
		(touch .gitignore && echo -e $(NAME)"\n"\
$(addprefix $(OBJDIR), "*") "\n*~" "\nsrc/*~" "\ninclude/*~" | cat > .gitignore); else \
		echo -e \'$(SALMON).gitignore$(CHERRY)\': file already exists; \
	fi
	$(ENDLOG)
