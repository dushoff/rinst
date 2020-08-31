## This is …

-include target.mk
all: target

# -include makestuff/perl.def

vim_session:
	bash -cl "vmt"

######################################################################

# It is better to only make here _as root_ (don't use sudo).  On new systems, sudo seems to install to the user location. On yushan, sudo _usually_ works fine, but it chokes on jags-y things.

###################################################################

bleeding: broom.mixed.github
current: ggfortify.install rstanarm.install jtools.install DHARMa.install pwr.install plot3D.install geomorph.install truncnorm.install epiDisplay.install animation.install rmutil.install EntropyEstimation.install furrr.install mobsim.install ismev.install PK.install nullabor.install stargazer.install sjPlot.install pgmm.install ggalt.install tabulizer.install sjPlot.install rattle.install LaCroixColoR.github googleVis.install gganimate.install ggmap.install sf.install geogrid.install gganimate.install tourr.install factoextra.install pheatmap.install glm2.install wesanderson.install andrews.install flextable.install arules.install ggraph.install cividis.github EMMIXskew.install gsheet.install gtrendsR.install factoextra.install av.install epigrowthfit.github roxygen2.install EpiEstim.install DEoptim.install mvbutils.install janitor.install expss.install diffeqr.install EnvStats.install surveillance.install shinyWidgets.install diagram.install

copy:
	/bin/cp -f Makefile ~/Dropbox/linux/home/R

## cp ubuntu.mk R.mk ##
Sources += ubuntu.mk
Ignore += R.mk
-include R.mk

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

makevars.Rout: makevars.R
	R --vanilla < $< > $@

Ignore += *.install *.nimble *.github *.bolker *.forge *.package *.fastinstall
%.install:
	 echo 'install.packages("$*", repos = "$(MAINR)", dependencies = TRUE)' | $(R) --vanilla > $@

%.fastinstall:
	 echo 'install.packages("$*", repos = "$(MAINR)")' | $(R) --vanilla > $@

%.nimble:
	 echo 'install.packages("$*", repos = "$(NIMBLE)", type="source")' | $(R) --vanilla > $@

bioconductor:
	echo 'source("http://bioconductor.org/biocLite.R"); biocLite()' | $(R) --vanilla > $@

%.bioconductor:
	echo 'source("http://bioconductor.org/biocLite.R"); biocLite("$*")' | $(R) --vanilla > $@

coin.install: devtools.install

nimble.dev: %.dev: devtools.install
	echo 'library(devtools); install.packages("$*", repos = "http://r-nimble.org", type = "source")' | sudo $(R) --vanilla > $@ 

# Bolker packages
broom.mixed.github bbmle.github bio3ss3.github fitsir.github: %.github: devtools.install
	echo 'library(devtools); install_github("bbolker/$*")' | sudo $(R) --vanilla > $@ 

# Other packages
epigrowthfit.github: %.github: devtools.install
	echo 'library(devtools); install_github("davidearn/$*")' | sudo $(R) --vanilla > $@ 

ggstance.github: %.github: devtools.install
	echo 'library(devtools); install_github("lionel-/$*")' | sudo $(R) --vanilla > $@ 

cividis.github: %.github: devtools.install
	echo 'library(devtools); install_github("marcosci/$*")' | sudo $(R) --vanilla > $@ 

LaCroixColoR.github: %.github: devtools.install
	echo 'library(devtools); install_github("johannesbjork/$*")' | sudo $(R) --vanilla > $@ 
#devtools::install_github("johannesbjork/LaCroixColoR")

polyreg.github: %.github: devtools.install
	echo 'library(devtools); install_github("matloff/$*")' | sudo $(R) --vanilla > $@ 

# Other packages
bsselectR.github: %.github: devtools.install
	echo 'library(devtools); install_github("walkerke/$*")' | sudo $(R) --vanilla > $@ 

# Other packages
wolframR.github: %.github: devtools.install
	echo 'library(devtools); install_github("parksw3/$*")' | sudo $(R) --vanilla > $@ 

lme4.github: %.github: devtools.install
	echo 'library(devtools); install_github("lme4/$*")' | sudo $(R) --vanilla > $@ 

# ICI3D (libary(ICI3D))
ici3d-pkg.github: %.github: devtools.install
	echo 'library(devtools); install_github("ICI3D/$*")' | sudo $(R) --vanilla > $@ 

ggplot2.github: %.github: devtools.install
	echo 'library(devtools); install_github("tidyverse/$*")' | sudo $(R) --vanilla > $@ 

ggord.github: %.github: devtools.install
	echo 'library(devtools); install_github("fawda123/$*")' | sudo $(R) --vanilla > $@ 

factoextra.github: %.github: devtools.install
	echo 'library(devtools); install_github("kassambara/$*")' | sudo $(R) --vanilla > $@ 

# Champredon

GI.github seminribm.github: %.github: devtools.install
	echo 'library(devtools); install_github("davidchampredon/$*", build_vignettes = TRUE, force=TRUE)' | sudo $(R) --vanilla > $@ 

broom.github: %.github: devtools.install
	echo 'library(devtools); install_github("bbolker/$*")' | sudo $(R) --vanilla > $@ 

## Needed for plague?
glmmTMB.github: %.github: devtools.install
	echo 'library(devtools); install_github("$*/$*/$*")' | sudo $(R) --vanilla > $@ 

lmPerm.github: %.github: devtools.install
	echo 'library(devtools); install_version("lmPerm", version="1.1-2", repos = "$(MAINR)")' | sudo $(R) --vanilla > $@ 

# coefplot2.bolker: lme4.0.forge

Phylogenetics.view:
	echo 'library("ctv"); install.views("Phylogenetics", repos="$(MAINR)")' | $(R) --vanilla > $@

# jags = /usr/local/JAGS/current
# rjags.install:
	# env LD_LIBRARY_PATH=$(jags)/lib echo 'install.packages("rjags", configure.args="--with-jags-include=$(jags)/include/JAGS --with-jags-lib=$(jags)/lib --with-jags-modules=$(jags)/lib/JAGS/modules-2.2.0", type="source", repos = "$(MAINR)")' | $(R) --vanilla >& $@

## Upgrade upgrade
update.%:
	 echo 'update.packages(repos = "$(MAINR)", ask=FALSE, checkBuilt=TRUE)' | $(R) --vanilla > $@

%.forge:
	 echo 'install.packages("$*", repos = "$(FORGE)")' | $(R) --vanilla > $@

%.lme:
	 echo 'install.packages("$*", repos = "$(LME)")' | sudo $(R) --vanilla > $@

%.rstan:
	 echo 'install.packages("$*", repos = "$(RSTAN)")' | sudo $(R) --vanilla > $@

%.bolker:
	 echo 'install.packages("$*", repos = "$(BOLKER)")' | $(R) --vanilla > $@

%.here: %.tgz
	$(R) CMD INSTALL $< > $@

################################################################

# Could have used forge (probably).  filehash Dependency is still relevant

tikzDevice.tgz: 
	wget -O $@ "http://probability.ca/cran/src/contrib/Archive/tikzDevice/tikzDevice_0.6.2.tar.gz"

tikzDevice.here: filehash.install

%.tgz:
	/bin/ln -s /home/R/$@

%.rmk:
	/bin/rm -f $*
	$(MAKE) $*

startpackages:
	touch $(startpackages)
startpackages =

vis: ggvis.install plotly.install highcharter.install googleVis.install shiny.install crosstalk.install

course: pander.install cowplot.install rainbow.install ggthemes.install directlabels.install 
over: Hmisc.install.rmk

lcmix.forge: matrixStats.install nnls.install

## rgdal.install: r-cran-sf.package
rgdal.install: libgdal-dev.package libproj-dev.package
sf.install: rgdal.install libudunits2-0.package libudunits2-dev.package

# tabulizer.install: rJava.stuff
gganimate.install: cargo.package

## 11 should be checked, I guess
rJava.stuff: openjdk-11-jdk.package rJava.install
	R CMD javareconf

## attempting ggalt 2019 Sep 30 (Mon)
## seems good, but not tested via make
ggalt.install: proj4.install
proj4.install: libproj-dev.package

animation.install: libmagick++-dev.package

rstanarm.install: libgfortran3.package

## Stuff I had in main install lists before 2019 Feb 27 (Wed)
legacies: Rpkg.install lmPerm.install mosaic.install corrplot.install DescTools.install nmf.install gsubfn.install ggstance.github XML.install httr.install downloader.install doMPI.install abind.install adaptivetau.install adephylo.install animation.install ape.install aspace.install bbmle.install bigmemory.install binom.install Biobase.install bioconductor Biostrings.bioconductor bstats.install calibrate.install car.install caTools.install CCA.install chron.install coefplot2.bolker concord.install contrast.install ctv.install cwhmisc.install DAAG.install DALY.install data.table.install Deducer.install demography.install deSolve.install devtools.install directlabels.install doMC.install dplyr.install ecodist.install edgeR.bioconductor emdbook.install epicalc.install epiR.install epitools.install fastICA.install fpc.install gdata.install foreign.install readstata13.install geepack.install GGally.install ggExtra.install ggmcmc.install ggplot2.install GillespieSSA.install gplots.install gridBase.install gridExtra.install gtools.install heplots.install highlight.install Hmisc.install homals.install igraph.install inline.install knitr.install lme4.install mapproj.install maps.install maptools.install markdown.install MASS.install Matrix.install MCMCglmm.install mcmcplots.install metafor.install minqa.install MiscPsycho.install mlmRev.install multcomp.install multcompView.install network.install NMF.install nortest.install odesolve.install optimx.install ordinal.install p3d.forge Phylogenetics.view pixmap.install plotGoogleMaps.install plotrix.install plyr.install pomp.install psych.install PVAClone.install pvclust.install R2WinBUGS.install RBioinf.bioconductor Rcapture.install RColorBrewer.install RcppEigen.install Rcpp.install RCurl.install reshape.install reshape2.install rgdal.install rgl.install RgoogleMaps.install rjags.install RMySQL.install phyloseq.bioconductor rstan.rstan Rwave.install sandwich.install scatterplot3d.install shiny.install sn.install spida.forge sp.install survey.install TeachingDemos.install tgp.install tidyr.install tikzDevice.install TTR.install vegan.install VGAM.install xtable.install coin.install lmPerm.github lubridate.install doBy.install logitnorm.install phylobase.install WGCNA.bioconductor topGO.bioconductor LifeTables.install synlik.install snowfall.install iNEXT.install rootSolve.install FME.install nimble.nimble TMB.install dotwhisker.install broom.github R0.install EpiEstim.install logisticPCA.install rmarkdown.install lhs.install RVAideMemoire.install resample.install rgeos.install GISTools.install wolframR.github effects.install lsmeans.install xlsx.install plotly.install googlesheets.install curl.install rstanarm.install cowplot.install PoisNor.install lcmix.forge ggforce.install ROCR.install caret.install ISLR.install broom.mixed.github bbmle.github Deriv.install huxtable.install emmeans.install glmmTMB.install neuralnet.install plm.install Rmisc.install

GISTools.install: rgeos.install

# PACKAGE is defined in R.mk; do apt-cache search r-cran to see a bunch that should probably be added.

resting: R2jags.install arm.install candisc.install 

# emdbook.install:
## doMPI seems broken due to R package weirdness 2018 Sep 18 (Tue)
## doMPI.install: r-cran-rmpi.package

devtools.install: libcurl4-openssl-dev.package libssl-dev.package

%.package:
	$(PACKAGE) $*
	touch $@

## rgl.install: r-cran-rgl.package
RVAideMemoire.install: r-cran-rgl.package

xlsx.install: r-cran-rjava.package

# Why were these commented out? May 2015
# I am commenting them out again because they are triggering errors. Haven't bothered to see what's up Sep 2015

## Changed on infinity; not tested
# tidyverse.install: libcurl4.openssl.dev.package r-cran-xml2.package

## Changed on screenbox, still not tested
tidyverse.install: libcurl4.openssl.dev.package libxml2.package libxml2-dev.package

## New tidy pain 2019 Sep 22 (Sun)
tidyverse.install: RMariaDB.install RPostgreSQL.install
RMariaDB.install: libssl1.0-dev.package libmysqlclient-dev.package
RPostgreSQL.install: postgresql.package postgresql-contrib.package libpq-dev.package

huxtable.install: officer.install gdtools.install
officer.install: xml2.install
xml2.install: libxml2.package
gdtools.install: libcairo2-dev.package

# phyloseq.bioconductor: r-cran-xml.package

## rjags.install: r-cran-rjags.package
rjags.install: jags.package
R2jags.install: rjags.install

# End of list

# Did not work on spruceside; probably installed lots of other places already
## Why not just tikzDevice.install?
broken = tikzDevice.here 

renew:
	/bin/rm -f *.install
	- /bin/rm -f *.forge
	- /bin/rm -f *.here
	- /bin/rm -f *bioconductor
	- /bin/rm -f *.bolker
	- /bin/rm -f *.lme

# Confusion
# coefplot.tgz provides package coefplot2.  This is Dushoff's fault; tgz should probably be renamed.

######## Cleaning #######

clean_packages:
	 echo 'ip <- installed.packages(); ap <- ip[!(ip[,"Priority"] %in% c("base", "recommended")), 1]; sapply(ap, remove.packages, lib=.libPaths())' | $(R) --vanilla 
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
