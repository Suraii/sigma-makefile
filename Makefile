##
## Sigma,
## the Makefile cephalon
## c programs object compilation tool
## -> Suraii
##

#----- COLORS -----#

NORMAL	=	"\e[0m"
BOLD	=	"\e[1m"
ITALIC  =	"\e[3m"
SALMON		=	"\e[38;5;217m"
CHERRY		=	"\e[38;5;167m"

#----- FLAGS -----#

MAKEFLAGS += --no-print-directory --silence --silent

#----- VARIABLES -----#

#--- Compilation
# [?] TO EDIT SRC DIRECTORIES OR BINARY NAME USE THE 'make set' & 'make add', ('make help' to get manuals)[?]
SRCDIRS = 	$(shell if ! [ -f .sigma/src ]; then (echo "src" > .sigma/src) fi ; cat .sigma/src)
SRC	=	$(shell find $(SRCDIRS) -maxdepth 1 -iname *.c)
INCLUDE	=	-Iinclude/
OBJDIR	=	objects
OBJSUBDIRS	=	$(addprefix $(OBJDIR)/, $(SRCDIRS))
OBJ	=	$(addprefix $(OBJDIR)/, $(addsuffix .o, $(basename $(SRC))))
NAME	=	$(shell if ! [ -f .sigma/name ]; then (echo "binary" > .sigma/name) fi ; cat .sigma/name)
CFLAGS	=	-Wall -Wextra $(INCLUDE)
DEBUGFLAGS =	-g3

#--- Speach
CHIP	=	$(BOLD)$(CHERRY)[$(SALMON)Σ$(CHERRY)]$(NORMAL)
DISP	=	echo -e $(TITLE)$(LIGHTGRAY)
SAY	=	echo -e $(CHIP) $(BOLD)
LOG	=	echo -e $(CHERRY) \>
MAN	=	echo -e $(BOLD)$(SALMON)-
ENDLOG	=	echo -e $(NORMAL)

#--- System
SYSFILES =	.sigma .sigma/fails .sigma/errors

#----- RULES -----#

.SILENT: all $(NAME) $(OBJ) $(OBJDIR) $(OBJSUBDIRS) clean clear fclean re introduce_compilation debug
.PHONY: re clean fclean introduce_compilation

all: $(NAME)
	if [ $(shell cat .sigma/errors) == 0 ] && [ $(shell cat .sigma/fails) == 0 ]; then \
		$(SAY)Everything compiled $(SALMON)successfully$(NORMAL)$(BOLD), \
seems like you finally succeed to code decently.$(NORMAL); else \
		$(SAY)Aannd you failed, try this out ':' \
\'$(SALMON)http://cforbeginners.com/$(NORMAL)$(BOLD)\' \($(shell cat .sigma/errors) file\(s\) fucked\)$(NORMAL); \
	fi && echo $(FAILS)
	$(MAKE) reset_fails
	$(MAKE) reset_errors

debug:
	$(SAY) You really want to see your $(SALMON)valgrind$(NORMAL)$(BOLD) logs ? \
I bet it\'s full of invalid reads \& memory leaks..$(NORMAL)
	$(LOG) Compiling $(SALMON)source $(CHERRY)with $(SALMON)debug $(CHERRY)options
	gcc $(CFLAGS) $(DEBUGFLAGS) $(SRC) -o $(NAME) \
		&& echo -e $(SALMON)$(NAME) $(CHERRY)builded ✔ \
		|| echo -e $(CHERRY)Couldn\'t build $(SALMON)$(NAME)$(CHERRY)✘
	$(SAY) If you failed compiling this you should try to $(SALMON)git gud
	$(ENDLOG)

introduce_compilation: $(SYSFILES)
	$(SAY)Okay, let\'s see if you fucked up your code$(NORMAL)
	$(LOG) Compiling $(SALMON)sources $(CHERRY)

$(NAME): introduce_compilation $(OBJDIR) $(OBJSUBDIRS) $(OBJ)
	$(LOG) Compiling $(SALMON)objects$(CHERRY)
	gcc $(CFLAGS) -o $(NAME) $(OBJ) \
		&& echo -e $(SALMON)$(NAME) $(CHERRY)builded ✔  \
		|| (echo -e Couldn\'t build $(SALMON)$(NAME)$(CHERRY)✘ ; $(MAKE) increment_fails)
	$(ENDLOG)

$(OBJDIR)/%.o: %.c
	gcc -c $< -o $@ $(CFLAGS) \
		&& echo -e $< $(SALMON)✔ $(CHERRY) \
		|| (echo -e $(BOLD)$(SALMON)+1$(NORMAL)$(CHERRY) file fucked$(NORMAL) ; $(MAKE) increment_errors)
	$(ENDLOG)

$(OBJDIR):
	mkdir objects
	$(LOG) Creating \'$(SALMON)objects$(CHERRY)\' directory$(NORMAL)

$(OBJSUBDIRS):
	$(LOG) Mirroring source $(SALMON)architecture$(CHERRY) in $(OBJDIR)
	mkdir -pv $(OBJSUBDIRS)
	$(ENDLOG)

clean:
	$(SAY)Cleaning objects ? Why the hell would you do that ?$(NORMAL)
	$(LOG) Cleaning $(SALMON)objects$(CHERRY) \(\'.o\' files just in case\)
	rm -vf $(OBJ)
	$(ENDLOG)

clear:
	$(SAY)Killing all temp files ? In my world we call that racism$(NORMAL)
	$(LOG) Clearing those damn $(SALMON)temp files$(CHERRY)
	find -iname *~ -printf "Deleted %f (%s bytes)\n" -delete
	find -iname \#*\# -printf "Deleted %f (%s bytes)\n" -delete
	find -iname vgcore.* -printf "Deleted %f (%s bytes)\n" -delete
	$(ENDLOG)

fclean: clean
	$(SAY)Time to burst some binary !..\'hmm\', excuse me, I meant\
 \'Deleting binary file\'$(NORMAL)
	$(LOG) Deleting $(SALMON)binary file$(CHERRY)
	rm -vf $(NAME)
	$(ENDLOG)

re: fclean all

#----- EDITING -----#

set: $(SYSFILES)
	if [ $(name) ]; then \
		if ! [ $(NAME) == $(name) ]; then \
			($(SAY)This name sucks, you crap $(NORMAL)\
			&& echo $(name) > .sigma/name \
			&& $(LOG) Binary name successfully changed to $(SALMON)$(name) && $(ENDLOG)); else \
			$(SAY)Binary is already named $(SALMON)$(name)$(NORMAL)$(BOLD), dumbnuts ! $(NORMAL); \
		fi; \
	fi
	if [ $(src) ]; then \
		($(SAY)$(SALMON)\[\!\] $(NORMAL)$(BOLD)Remember: don\'t put the \'\/\' at the end of your dir names $(NORMAL)\
			&& echo $(src) > .sigma/src \
			&& $(LOG) Source directories successfully set to \'$(SALMON)$(src)$(CHERRY)\' && $(ENDLOG)); \
	fi

add: $(SYSFILES)
	if [ $(src) ]; then \
		($(SAY)$(SALMON)\[\!\] $(NORMAL)$(BOLD)Remember: don\'t put the \'\/\' at the end of your dir names $(NORMAL)\
			&& echo $(src) >> .sigma/src \
			&& $(LOG) $(SALMON)$(src)$(CHERRY) successfully added to source directories && $(ENDLOG)); \
	fi

#----- SYSTEM -----#

.PHONY: increment_fails reset_fails increment_errors reset_errors
.SILENT: $(SYSFILES) increment_fails reset_fails increment_errors reset_errors

$(SYSFILES):
	mkdir -pv .sigma
	echo 0 > .sigma/fails
	echo 0 > .sigma/errors

increment_fails: $(SYSFILES)
	$(shell echo $$((`cat ".sigma/fails"` + 1)) > .sigma/fails)

reset_fails: $(SYSFILES)
	echo 0 > .sigma/fails

increment_errors: $(SYSFILES)
	$(shell echo $$((`cat ".sigma/errors"` + 1)) > .sigma/errors)

reset_errors: $(SYSFILES)
	echo 0 > .sigma/errors

#----- INTERACTIONS -----#

.PHONY: hello listsrc joke help credits listobj
.SILENT: hello help credits joke listsrc listobj install

hello:
	$(SAY)$(SALMON)\"$(NORMAL)$(BOLD)Greetings master, I\'m $(SALMON)Sigma$(NORMAL)\
$(BOLD), the Makefile cephalon.$(NORMAL)
	$(SAY) I hope my poorly-programmed system will be able to help you in your tasks !$(NORMAL)
	$(SAY) Make sure to try \'$(SALMON)make help$(NORMAL)$(BOLD)\' if you have the \
mental capacities to read a manual \(most of the programmers don\'t\)$(SALMON)$(BOLD)\"$(NORMAL)

help:
	$(SAY)Oh, finally someone brave enough to read a $(SALMON)manual$(NORMAL)
	$(MAN) hello $(NORMAL)$(CHERRY)':' Allow me to introduce myself$(NORMAL)
	$(MAN) make, re, clean, fclean $(NORMAL)$(CHERRY)':' Come on, don\'t tell me you don\'t know these$(NORMAL)
	$(MAN) debug $(NORMAL)$(CHERRY)':' Compile with debug flags \(-g3 by default, customisable\)
	$(MAN) clear $(NORMAL)$(CHERRY)':' Clean the temp files \(*~, mainly\)$(NORMAL)
	$(MAN) install $(NORMAL)$(CHERRY)':' Create your \'src\', \'objects\' \& \'include\' \
folders if they don\'t exist \(+ a filled .gitignore file\)$(NORMAL)
	$(MAN) set $(NORMAL)$(CHERRY)':' Allow you to edit compilation options such as source directories or\
 binary name, type \'$(SALMON)make set_help$(CHERRY)\' to get the manual$(NORMAL)
	$(MAN) add $(NORMAL)$(CHERRY)':' Like set rule but will append previous value instead of \
overwritting it, type \'$(SALMON)make add_help$(CHERRY)\' to get the manual$(NORMAL)
	$(MAN) listsrc $(NORMAL)$(CHERRY)':' List your source files$(NORMAL)
	$(MAN) listobj $(NORMAL)$(CHERRY)':' List your obj files, you\'re probably too dumb to understand \
why it is usefull$(NORMAL)
	$(MAN) joke $(NORMAL)$(CHERRY)':' Let me tell you the best joke ever$(NORMAL)
	$(MAN) help $(NORMAL)$(CHERRY)':' Are you fucking kidding me ?$(NORMAL)
	$(MAN) credits $(NORMAL)$(CHERRY)':' Let you have more details about me \& my creator$(NORMAL)

set_help:
	$(SAY)My creator is really proud of this useless $(SALMON)feature$(NORMAL)$(BOLD), \
but you can still tell him it $(SALMON)sucks$(NORMAL)$(BOLD) if needed $(NORMAL)
	$(LOG) Set allows you to $(SALMON)set $(CHERRY)one of the $(SALMON)customisable variables$(CHERRY) \
to a given value
	$(LOG) $(SALMON)$(BOLD)USAGE ':'$(NORMAL)$(CHERRY) make set \
$(ITALIC)$(SALMON)variable_name$(NORMAL)$(CHERRY)$(BOLD)=$(NORMAL)$(ITALIC)$(SALMON)new_value$(NORMAL)
	$(MAN) variable_name $(NORMAL)$(CHERRY)':' One from the following list
	$(MAN) "\t"src $(NORMAL)$(CHERRY)':' List of the source directories $(SALMON)[!] WITHOUT THE \'/\'
	$(MAN) "\t"name $(NORMAL)$(CHERRY)':' Binary\'s \(executable file\) name
	$(MAN) new_value $(NORMAL)$(CHERRY)':' The value that you want to assign $(SALMON)\
[!] THE PREVIOUS VALUE WILL BE OVERWRITTED
	$(LOG) $(SALMON)$(BOLD)EXAMPLE ':'$(NORMAL)$(CHERRY) \"make set \
$(SALMON)name$(CHERRY)=$(SALMON)execute_me$(CHERRY)\" will set $(SALMON)name$(CHERRY)\'s value to $(SALMON)execute_me
	$(ENDLOG)

add_help:
	$(SAY)This feature is $(SALMON)µ'$'USEFULL & PERFECTLY CODDED'$'*²\
$(NORMAL)$(BOLD), my master forced me to say that, sorry.
	$(LOG) Add allows you to $(SALMON)append $(CHERRY)a given value to\
one of the $(SALMON)customisable variables$(CHERRY)
	$(LOG) $(SALMON)$(BOLD)USAGE ':'$(NORMAL)$(CHERRY) make add \
$(ITALIC)$(SALMON)variable_name$(NORMAL)$(CHERRY)$(BOLD)=$(NORMAL)$(ITALIC)$(SALMON)append_value$(NORMAL)
	$(MAN) variable_name $(NORMAL)$(CHERRY)':' One from the following list
	$(MAN) "\t"src $(NORMAL)$(CHERRY)':' List of the source directories $(SALMON)[!] WITHOUT THE \'/\'
	$(MAN) append_value $(NORMAL)$(CHERRY)':' The value that you want to append
	$(LOG) $(SALMON)$(BOLD)EXAMPLE ':'$(NORMAL)$(CHERRY) \"make add \
$(SALMON)src$(CHERRY)=$(SALMON)src/new$(CHERRY)\" will add $(SALMON)src/new $(CHERRY)to $(SALMON)src
	$(ENDLOG)

credits:
	$(SAY)Oh, you want more details about me ?
	$(SAY) As you already know my name is $(SALMON)Sigma$(NORMAL)$(BOLD), it means
	$(SAY) Super Intelligent Genderless MAkefile
	$(SAY) I have been created by a shitty edgy weirdo named \'$(SALMON)Suraii$(NORMAL)$(BOLD)\'
	$(SAY) If you want to tell him how bad he is at programming here\'s his discord ':'
	$(SAY) '->' Suraii#6133 \(Care, he is very edgy\)$(NORMAL)

joke:
	$(SAY)What\'s my name ?$(NORMAL)
	sleep 2
	$(SAY)Sigma balls nibba \(if you don\'t find this funny, then care, you probably have ligma\)$(NORMAL)

listsrc:
	$(SAY)Okay let\'s display all these sources
	$(LOG) $(SALMON)source$(CHERRY) files ':'
	for file in $(SRC); do\
		echo $$file;\
	done
	$(ENDLOG)

listobj:
	$(SAY)Can we call this \'object-oriented\' programming ?
	$(LOG) $(SALMON)obj$(CHERRY) files ':'
	for file in $(OBJ); do\
		echo $$file;\
	done
	$(ENDLOG)

install: $(SYSFILES)
	$(SAY)Do your work ? what do you think I am, a maid ? Oh yes, it\'s my function, shitty life..
	$(LOG) Installing basic architecture
	if ! [ -d "src" ]; then \
		mkdir src; else \
		echo -e \'$(SALMON)src$(CHERRY)\': directory already exists; \
	fi
	if ! [ -d "include" ]; then \
		mkdir include; else \
		echo -e \'$(SALMON)include$(CHERRY)\': directory already exists; \
	fi
	$(LOG) Installing .gitignore
	if ! [ -d ".gitignore" ]; then \
		(touch .gitignore && echo -e $(NAME)"\n" ".sigma\n"\
$(addprefix $(OBJDIR), "*") "\n*~" "\nsrc/*~" "\ninclude/*~" | cat > .gitignore); else \
		echo -e \'$(SALMON).gitignore$(CHERRY)\': file already exists; \
	fi
	$(ENDLOG)
