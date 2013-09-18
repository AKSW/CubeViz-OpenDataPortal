<?php
/**
 * This file is part of the {@link http://ontowiki.net OntoWiki} project.
 *
 * @copyright Copyright (c) 2012, {@link http://aksw.org AKSW}
 * @license   http://opensource.org/licenses/gpl-license.php GNU General Public License (GPL)
 */

/**
 * OntoWiki module – modellist
 *
 * Shows a list of all models in a store
 *
 * @category   OntoWiki
 * @package    Extensions_Modellist
 * @author     Norman Heino <norman.heino@gmail.com>
 * @author     Philipp Frischmuth <pfrischmuth@googlemail.com>
 * @copyright  Copyright (c) 2012, {@link http://aksw.org AKSW}
 * @license    http://opensource.org/licenses/gpl-license.php GNU General Public License (GPL)
 */
class ModellistModule extends OntoWiki_Module
{
    public function init()
    {
        $menuRegistry = OntoWiki_Menu_Registry::getInstance();
        $menuRegistry->getMenu('application')->getSubMenu('View')->setEntry('Hide Knowledge Bases Box', '#');

        $this->session          = new Zend_Session_Namespace(_OWSESSION);
        $this->allGraphUris     = $this->_store->getAvailableModels(false);
        $this->visibleGraphUris = $this->_store->getAvailableModels(false);

        if (isset($this->session->showHiddenGraphs) && $this->session->showHiddenGraphs == true) {
            $this->graphUris = $this->allGraphUris;
        } else {
            $this->graphUris = $this->visibleGraphUris;
        }
    }


    public function shouldShow()
    {
        // show only if there are models (visible or hidden)
        if (($this->allGraphUris) || ($this->_erfurt->getAc()->isActionAllowed('ModelManagement'))) {
            return true;
        }

        return false;
    }

    /**
     * Returns the content for the model list.
     */
    public function getContents()
    {
        $models        = array();
        $selectedModel = $this->_owApp->selectedModel ? $this->_owApp->selectedModel->getModelIri() : null;

        $lang = $this->_config->languages->locale;

        $titleHelper = new OntoWiki_Model_TitleHelper();
        #$titleHelper->addResources(array_keys($this->graphUris));

        $useGraphUriAsLink = false;
        if (isset($this->_privateConfig->useGraphUriAsLink) && (bool)$this->_privateConfig->useGraphUriAsLink) {
            $useGraphUriAsLink = true;
        }

        foreach ($this->graphUris as $graphUri => $true) {
            $linkUrl = $this->_config->urlBase . 'model/select/?m=' . urlencode($graphUri);
            if ($useGraphUriAsLink) {
                if (isset($this->_config->vhosts)) {
                    $vHostsArray = $this->_config->vhosts->toArray();
                    foreach ($vHostsArray as $vHostUri) {
                        if (strpos($graphUri, $vHostUri) !== false) {
                            // match
                            $linkUrl = $graphUri;
                            break;
                        }
                    }
                }
            }

            $temp             = array();
            $temp['url']      = $linkUrl;
            $temp['graphUri'] = $graphUri;
            $temp['selected'] = ($selectedModel == $graphUri ? 'selected' : '');

            if(!isset($_SESSION[_OWSESSION]['labels']['graph'][$graphUri])) {
                $titleHelper->addResource($graphUri);
            }
            
            $temp['label'] = !empty($label) ? $label : $graphUri;
            $temp['backendName'] = $true;

            $models[$graphUri] = $temp;
        }
        
        foreach ($models as $graphUri => $graph) {
            if(!isset($_SESSION[_OWSESSION]['labels']['graph'][$graphUri])) {
                $label = $titleHelper->getTitle($graphUri, $lang);
                $_SESSION[_OWSESSION]['labels'][$graphUri] = $label;
            } else {
                $label = $_SESSION[_OWSESSION]['labels']['graph'][$graphUri];
            }
            $label = !empty($label) ? $label : $graphUri;
            
            $models[$graphUri]['label'] = $label;
        }
        
        $this->view->cubevizUrl = $this->_config->urlBase . 'cubeviz/modelinfo/';
        
        /**
         * Add javascript and css file
         */
        $basePath = $this->view->basePath = $this->_config->urlBase . 'extensions/modellist/';
        
        $this->view->headScript()->appendFile ($basePath .'public/javascript/modellist.js', 'text/javascript');        
        $this->view->headLink()->appendStylesheet($basePath .'public/css/main.css');
        
        return $this->render('modellist', $models, 'models');
    }

    public function getStateId()
    {
        $session = new Zend_Session_Namespace(_OWSESSION);
        if (isset($session->showHiddenGraphs) && $session->showHiddenGraphs == true) {
            $showHidden = 'true';
        } else {
            $showHidden = 'false';
        }

        $id = (string)$this->_owApp->getUser()->getUri()
            . $this->_owApp->selectedModel
            . $showHidden;

        return $id;
    }

    public function getTitle()
    {
        return '<div class="smallHeadline">
                    &nbsp;Models of selected SPARQL endpoint</div><br/>';
    }

}
