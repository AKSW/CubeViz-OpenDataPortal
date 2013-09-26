default:
	@echo "CLI - CubeViz OpenDataPortal Deployment"
	@echo ""
	@echo "  use "
	@echo "     'make install' to setup this repository"
	@echo "     'make package' to create an archive containing an OntoWiki, Erfurt, "
	@echo "                    CubeViz, ..., runable out-of-the-box!"

install:
	@echo ""
	@echo ""
	@echo "######################################################"
	@echo "Install OntoWiki (branch feature/remoteSparqlEndpoint)"	
	@echo "######################################################"
	@echo ""
	git clone https://github.com/AKSW/OntoWiki.git application
	cd application && git checkout feature/remoteSparqlEndpoint && git pull
	
	@echo ""
	@echo ""
	@echo "##############"
	@echo "Setup OntoWiki"	
	@echo "##############"
	@echo ""
	cd application && make deploy
	
	@echo ""
	@echo ""
	@echo "###################################################"
	@echo "Install Erfurt (branch feature/remoteSparqlEndpoint)"	
	@echo "###################################################"
	@echo ""
	cd application/libraries/Erfurt && git fetch && git checkout feature/remoteSparqlEndpoint
	
	@echo ""
	@echo ""
	@echo "#########################################"
	@echo "Install and setup CubeViz (branch master)"	
	@echo "#########################################"
	@echo ""
	cd application/extensions && git clone https://github.com/AKSW/cubeviz.ontowiki.git cubeviz && cd cubeviz && git checkout master && make install
	
	@echo ""
	@echo ""
	@echo "################################################"
	@echo "Install and setup sparqlservices (branch master)"	
	@echo "################################################"
	@echo ""
	cd application/extensions && git clone https://github.com/AKSW/sparqlservices.ontowiki.git sparqlservices
	cp assets/extensions/sparqlservices/doap.n3 application/extensions/sparqlservices
	
	@echo ""
	@echo ""
	@echo "########################################"
	@echo "Copy pre-configured extensions and theme"
	@echo "########################################"
	@echo ""
	rm -rf application/extensions/modellist
	cp -R assets/extensions/modellist application/extensions
	cp -R assets/extensions/page application/extensions
	cp -R assets/extensions/staticlinks application/extensions
	cp -R assets/extensions/themes/odp_cubeviz application/extensions/themes
	
	@echo ""
	@echo ""
	@echo "##############################"
	@echo "Copy pre-configured extensions"
	@echo "##############################"
	@echo ""
	cp -R assets/deactivated-extensions/* application/extensions
	
	@echo ""
	@echo ""
	@echo "#########################################"
	@echo "Copy pre-configured config.ini"	
	@echo "#########################################"
	@echo ""
	cp assets/config.ini application/config.ini
	
	@echo " "
	@echo " "
	@echo "##################################################"
	@echo "... do not forget"
	@echo "    > to create a symbolic link to application folder"
	@echo "##################################################"
	@echo ""

make package:
	sh scripts/createPackage.sh
