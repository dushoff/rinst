## This is rinst

-include target.mk
all: target

# -include makestuff/perl.def

vim_session:
	bash -cl "vmt"

######################################################################

current: glmmTMB_extend.github

# It is better to only make here _as root_ (don't use sudo).  On new systems, sudo seems to install to the user location. On yushan, sudo _usually_ works fine, but it chokes on jags-y things.

## Old Makefile
Sources += install.mk paths.mk

Ignore += *.tmp

######################################################################

FORGE = http://R-Forge.R-project.org
LME = http://lme4.r-forge.r-project.org/repos
RSTAN = http://wiki.rstan-repo.googlecode.com/git/
CRAN = http://lib.stat.cmu.edu/R/CRAN
TORONTO = http://cran.utstat.utoronto.ca
MIRR = http://probability.ca/cran
CLOUD = cloud.r-project.org
BOLKER = http://www.math.mcmaster.ca/bolker/R
NIMBLE = http://r-nimble.org

MAINR = $(CRAN)

######################################################################

-include R.mk

######################################################################

Ignore += *.ppa *.apt *.source

%.ppa: r-cran-%.apt ;

aptrule = apt install -y $* | tee $*.apt
%.apt:
	$(aptrule)

sourcerule = echo 'install.packages("$*", repos = "$(MAINR)", dependencies = TRUE)' | $(R) --vanilla | tee $*.source
%.source:
	 $(sourcerule)

######################################################################

Ignore += *.github

%.github:
	echo 'library(remotes); install_github("$(gituser)/$*")' | $(R) --vanilla | tee $@ 

shellpipes.github: gituser=dushoff

rRlinks.github: gituser=mac-theobio

ggstance.github: %.github: remotes.install
	echo 'library(remotes); install_github("lionel-/$*")' | sudo $(R) --vanilla > $@ 

githubrule = ($(MAKE) $(@:.install=.github) && $(MV) $(@:.install=.github) $@) \
	|| ($(RM) $*.github && false)


######################################################################

## Work on modularizing

# Bolker packages
broom.mixed.github bbmle.github bio3ss3.github fitsir.github: gituser=bbolker

bbmle.install: 
	$(githubrule)

######################################################################

ici3d-pkg.github: gituser=ICI3D
ici3d-pkg.install:
	$(githubrule)

######################################################################

## Special extension from Steve

glmmTMB_extend.github:
	echo 'library(remotes);install_github("glmmTMB/glmmTMB/glmmTMB@extend_emmeans")' | $(R) --vanilla | tee $@ 

glmmTMB_extend.install:
	$(githubrule)

######################################################################

Ignore += *.install

%.install:
	($(MAKE) $*.ppa && $(MV) $*.apt $@) \
	|| ($(RM) $*.apt && ($(sourcerule)) && $(MV) $*.source $@) \
	|| ($(RM) $*.source && false)

######################################################################

## Dependencies

devtools.source: libharfbuzz-dev.apt libfribidi-dev.apt pkgload.install

######################################################################

## See linux-config/log for upgrading
## Upgrade updates

Ignore += update.*
update.%:
	 echo 'update.packages(repos = "$(MAINR)", ask=FALSE, checkBuilt=TRUE)' | $(R) --vanilla > $@

######################################################################

%.rmk:
	/bin/rm -f $*
	$(MAKE) $*

######################################################################

### Makestuff

Sources += Makefile

Ignore += makestuff
msrepo = https://github.com/dushoff

## Want to chain and make makestuff if it doesn't exist
## Compress this ¶ to choose default makestuff route
Makefile: makestuff/Makefile
makestuff/Makefile:
	git clone $(msrepo)/makestuff
	ls makestuff/Makefile

-include makestuff/os.mk

## -include makestuff/wrapR.mk

-include makestuff/git.mk
-include makestuff/visual.mk
-include makestuff/projdir.mk
