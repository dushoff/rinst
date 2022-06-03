## This is rinst

all: current target
-include target.mk

# -include makestuff/perl.def

vim_session:
	bash -cl "vmt"

######################################################################

MV = mv -f

current: glmmTMB.install glmmTMB_extend.github splitstackshape.install caret.install ggrepel.install FactoMineR.install rjags.install R2jags.install ungeviz.github matlib.install kdensity.install latex2exp.install rootSolve.install rtFilterEstim.install date.install remotes.install memoise.install directlabels.install cowplot.install EpiEstim.install egg.install tikzDevice.install lmPerm.install ggpubr.install gsheet.install gsheets.install shellpipes.github ggtext.install datadrivencv.github arm.install VGAM.install rstan.install performance.install TMB.source tidyverse.install haven.install bbmle.install devtools.install bsts.install emmeans.install effects.install ggthemes.install Cairo.install openxlsx.install ggdark.install ggpubfigs.github emdbook.install satpred.github logitnorm.install expss.install table1.install kableExtra.install survivalROC.install

trouble: ragg.install

macpan: pomp.install Hmisc.install DEoptim.install deSolve.install diagram.install fastmatrix.install semver.install

dataviz: huxtable.install rmarkdown.install ggExtra.install patchwork.install rainbow.install GGally.install rayshader.install hexbin.install agridat.install skimr.install pgmm.install stargazer.install dotwhisker.install hrbrthemes.install tidyquant.install paletteer.install ggstream.install streamgraph.github gtsummary.install gganimate.install wbstats.install gifski.install leaflet.install d3scatter.github threejs.install igraph.install network.install sna.install ggraph.install visNetwork.install networkD3.install ndtv.install factoextra.install vegan.install andrews.install tourr.install rggobi.install pheatmap.install ggmosaic.install ggeffects.install ggraph.install dichromat.install cividis.github colorBlindness.install ggmap.install palmerpenguins.install ggbeeswarm.install colorblindr.github pander.install

student: sqldf.install rworldmap.install ggplotFL.source shinythemes.source ggpmisc.install sarima.install dynlm.install move.install imputeTS.install

bicko: pacman.install

macpan_deps: pomp.install bbmle.install Hmisc.install DEoptim.install mvtnorm.install bdsmatrix.install zoo.install deSolve.install diagram.install doParallel.install fastmatrix.install

research: formattable.install

performance.install: see.install


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

REPO = $(CRAN)

######################################################################

## cp debian.mk R.mk ##
## Make this a link? Update?
Sources += debian.mk
Ignore += R.mk
-include R.mk

######################################################################

textshaping.install.isallfucked:
	R CMD INSTALL --configure-vars='INCLUDE_DIR=/usr/include/harfbuzz/'
	/tmp/RtmpANWJhr/downloaded_packages/

## apt install libfontconfig1-dev pkgconfiglib freetype-dev libfreetype6 libfreetype6-dev
##         ‘/tmp/RtmpmRc6FB/downloaded_packages’
#  remotes::install_github('r-lib/systemfonts')

######################################################################

Ignore += *.ppa *.apt *.source

%.ppa: r-cran-%.apt
	$(move)

aptrule = apt-get install -y ` echo $* | tr '[:upper:]' '[:lower:]' ` && touch $@
%.apt:
	$(aptrule)

## Aggro!
aggrule = echo 'install.packages("$*", repos = "$(REPO)", dependencies = TRUE)' | $(R) --vanilla && touch $@
%.agg:
	 $(aggrule)

## Default: c("Depends", "Imports", "LinkingTo")
sourcerule = echo 'install.packages("$*", repos = "$(REPO)")' | $(R) --vanilla && touch $*.source
%.source:
	 $(sourcerule)

## No dependencies
nsrule = echo 'install.packages("$*", repos = "$(REPO)", dependencies = FALSE)' | $(R) --vanilla && touch $@
%.ns:
	 $(nsrule)

######################################################################

Ignore += *.github

gforce = FALSE
%.github: | remotes.install
	echo 'library(remotes); install_github("$(gituser)/$*", force=$(gforce))' | $(R) --vanilla && touch $@

glmnetpostsurv.github: gituser=cygubicko
satpred.github: gituser=cygubicko
satpred.github: gforce=TRUE
satpred.github: gbm.install glmnetpostsurv.github pec.install survivalmodels.install

datadrivencv.github: gituser=nstrayer

systemfonts.github: gituser=r-lib

d3scatter.github: gituser=jcheng5

shellpipes.github: gituser=dushoff

rRlinks.github: gituser=mac-theobio

ungeviz.github: gituser=wilkelab
colorblindr.github: gituser=clauswilke

streamgraph.github: gituser=hrbrmstr

cividis.github: gituser=marcosci

ggpubfigs.github: gituser=JLSteenwyk

ggstance.github: %.github: remotes.install
	echo 'library(remotes); install_github("lionel-/$*")' | sudo $(R) --vanilla > $@ 

githubrule = ($(MAKE) $(@:.install=.github) && $(MV) $(@:.install=.github) $@) \
	|| ($(RM) $*.github && false)

######################################################################

ggplotFL.source: REPO = http://flr-project.org/R

######################################################################
## Work on modularizing

# Bolker packages
broom.mixed.github bbmle.github bio3ss3.github fitsir.github: gituser=bbolker

bbmle.install: 
	$(githubrule)

######################################################################

ici3d-pkg.github: gituser=ICI3D
ici3d-pkg.github: gforce=TRUE
ici3d-pkg.install:
	$(githubrule)

######################################################################

Ignore += bioconductor
bioconductor: BiocManager.install
	echo 'BiocManager::install(version = "3.13", ask=FALSE)' | $(R) --vanilla > $@

Ignore += *.bioconductor
%.bioconductor: bioconductor
	echo 'BiocManager::install("$*", version = "3.13")' | $(R) --vanilla > $@

######################################################################

## Special extension from Steve

pcoxtime: doParallel.install foreach.install prodlim.install riskRegression.install PermAlgo.install pec.install RcppArmadillo.install

glmmTMB_extend.github: emmeans.install
	echo 'library(remotes);install_github("glmmTMB/glmmTMB/glmmTMB@extend_emmeans")' | $(R) --vanilla | tee $@ 

glmmTMB_extend.install:
	$(githubrule)

######################################################################

rtFilterEstim.github: gituser=matthewcso
rtFilterEstim.install:
	$(githubrule)


######################################################################

## crancache pacman

Ignore += *.install

## I think this is all fixed including downcasing (search tr) 2021 Oct 15 (Fri)
## Seems to be making the target when failing (ragg.install)?
%.install:
	($(MAKE) $*.ppa && $(MV) $*.ppa $@) \
	|| (($(sourcerule)) && $(MV) $*.source $@) \
	|| ($(RM) $*.source && false)

######################################################################

## Dependencies

tikzDevice.install: Cairo.install

gifski.ppa: cargo.apt

move.install: rgdal.install
GGally.install: rJava.install
rJava.install: default-jre.apt

rmarkdown.install: openssl.install

openssl.install: sodium.install libssl-dev.apt

## sodium.install: libsodium.apt

ragg.install: textshaping.install
textshaping.install: libharfbuzz-dev.apt libfribidi-dev.apt pkgload.install
devtools.source: libharfbuzz-dev.apt libfribidi-dev.apt pkgload.install

dotwhisker.install: broomExtra.install

broomExtra.install: broom.install

broom.install: slider.install

slider.install: vctrs.install

gdtools.install: libcairo2-dev.apt

sf.install: rgdal.install libudunits2-0.apt libudunits2-dev.apt
rgdal.install: libgdal-dev.apt libproj-dev.apt

## This seems unavailable
RVAideMemoire.install: mixOmics.bioconductor
RVAideMemoire.install: %.install: Makefile
	$(nsrule)

######################################################################

## Belatedly tracking what I'm installing 2021 Jan 30 (Sat)

708: phyloseq.bioconductor microbiome.bioconductor here.install asnipe.install plot.matrix.install filesstrings.install

######################################################################

## See linux-config/log for upgrading
## Upgrade updates

Ignore += update.*
update.%:
	 echo 'update.packages(repos = "$(REPO)", ask=FALSE, checkBuilt=TRUE)' | $(R) --vanilla > $@

######################################################################

%.rmk:
	/bin/rm -f $*
	$(MAKE) $*

Ignore += *.tmp
%.rmk:
	$(RM) $* 
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
