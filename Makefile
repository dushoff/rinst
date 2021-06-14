## This is rinst

all: current
-include target.mk

# -include makestuff/perl.def

vim_session:
	bash -cl "vmt"

######################################################################

## See linux-config/log for upgrading. [Maybe 2021 Jun 10 (Thu)]

current: glmmTMB_extend.github splitstackshape.install caret.install ggrepel.install FactoMineR.install factoextra.install rjags.install R2jags.install matlib.install kdensity.install

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

nsrule = echo 'install.packages("$*", repos = "$(MAINR)", dependencies = FALSE)' | $(R) --vanilla | tee $*.source
%.ns:
	 $(nsrule)

######################################################################

Ignore += *.github

%.github:
	echo 'library(remotes); install_github("$(gituser)/$*")' | $(R) --vanilla | tee $@ 

shellpipes.github: gituser=dushoff

ungeviz.github: gituser=wilkelab

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

bioconductor: BiocManager.install
	echo 'BiocManager::install(version = "3.12")' | $(R) --vanilla > $@

%.bioconductor: bioconductor
	echo 'BiocManager::install("$*")' | $(R) --vanilla > $@

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


dotwhisker.install: broomExtra.install

broomExtra.install: broom.install

broom.install: slider.install

slider.install: vctrs.install

gdtools.install: libcairo2-dev.apt

sf.install: rgdal.install libudunits2-0.apt libudunits2-dev.apt
rgdal.install: libgdal-dev.apt libproj-dev.apt

######################################################################

## Belatedly tracking what I'm installing 2021 Jan 30 (Sat)

708: phyloseq.bioconductor microbiome.bioconductor here.install asnipe.install plot.matrix.install filesstrings.install

######################################################################

current: glmmTMB_extend.github splitstackshape.install caret.install ggrepel.install FactoMineR.install factoextra.install rjags.install R2jags.install ungeviz.github

pcoxtime: doParallel.install foreach.install prodlim.install riskRegression.install PermAlgo.install pec.install RcppArmadillo.install

# It is better to only make here _as root_ (don't use sudo).  On new systems, sudo seems to install to the user location. On yushan, sudo _usually_ works fine, but it chokes on jags-y things.

## Old Makefile
Sources += install.mk paths.mk

Ignore += *.tmp

######################################################################

%.rmk:
	$(RM) $* 
	$(MAKE) $* 

MV = mv -f

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

## Debian only; fancify later
Ignore += R.mk
-include R.mk

