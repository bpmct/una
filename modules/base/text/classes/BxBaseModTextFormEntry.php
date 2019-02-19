<?php defined('BX_DOL') or die('hack attempt');
/**
 * Copyright (c) UNA, Inc - https://una.io
 * MIT License - https://opensource.org/licenses/MIT
 *
 * @defgroup    BaseText Base classes for text modules
 * @ingroup     UnaModules
 *
 * @{
 */

/**
 * Create/Edit entry form
 */
class BxBaseModTextFormEntry extends BxBaseModGeneralFormEntry
{
    protected $_sGhostTemplateVideo = 'form_ghost_template_video.html';

    public function __construct($aInfo, $oTemplate = false)
    {
        parent::__construct($aInfo, $oTemplate);
    }

    function getCode($bDynamicMode = false)
    {
        $CNF = &$this->_oModule->_oConfig->CNF;

        $sResult = parent::getCode($bDynamicMode);
        $sResult .= $this->_oModule->_oTemplate->getJsCode('poll');

        if(!empty($CNF['OBJECT_MENU_ENTRY_ATTACHMENTS']))
            $sResult = $this->_oModule->_oTemplate->parseHtmlByContent($sResult, array(
                'attachments_menu' => BxDolMenu::getObjectInstance($CNF['OBJECT_MENU_ENTRY_ATTACHMENTS'])->getCode()
            ));

        $this->_oModule->_oTemplate->addJs(array('polls.js'));
    	return $sResult;
    }

    function initChecker ($aValues = array (), $aSpecificValues = array())
    {
        $CNF = &$this->_oModule->_oConfig->CNF;

        $bValues = $aValues && !empty($aValues['id']);
        $aContentInfo = $bValues ? $this->_oModule->_oDb->getContentInfoById($aValues['id']) : false;

        if (isset($CNF['FIELD_VIDEO']) && isset($this->aInputs[$CNF['FIELD_VIDEO']])) {
            if ($bValues)
                $this->aInputs[$CNF['FIELD_VIDEO']]['content_id'] = $aValues['id'];

            $this->aInputs[$CNF['FIELD_VIDEO']]['ghost_template'] = $this->_oModule->_oTemplate->parseHtmlByName($this->_sGhostTemplateVideo, $this->_getVideoGhostTmplVars($aContentInfo));
        }

        if (isset($CNF['FIELD_POLL']) && isset($this->aInputs[$CNF['FIELD_POLL']])) {
            if ($bValues)
                $this->aInputs[$CNF['FIELD_POLL']]['content_id'] = $aValues['id'];
        }

        parent::initChecker ($aValues, $aSpecificValues);
    }

    protected function genCustomInputAttachments ($aInput)
    {
        return '__attachments_menu__';
    }

    protected function genCustomInputPolls ($aInput)
    {
        $this->_oModule->_oTemplate->addCss(array('polls.css'));

        return $this->_oModule->_oTemplate->getPollField(!empty($aInput['content_id']) ? (int)$aInput['content_id'] : 0);
    }

    public function processPolls ($sFieldPoll, $iContentId = 0)
    {
        $CNF = &$this->_oModule->_oConfig->CNF;

        if (!isset($this->aInputs[$sFieldPoll]))
            return true;

        $aPollIds = $this->getCleanValue($sFieldPoll);
        if(empty($aPollIds) || !is_array($aPollIds))
            return true;

        $iProfileId = $this->getContentOwnerProfileId($iContentId);

        $aPollsDbIds = $this->_oModule->_oDb->getPolls(array('type' => 'content_id_ids', 'content_id' => $iContentId));

        //--- Remove deleted
        $this->_oModule->_oDb->deletePollsByIds(array_diff($aPollsDbIds, $aPollIds));

        //--- Add new
        if($iContentId) {
            $aPollsAddIds = array_diff($aPollIds, $aPollsDbIds);
            foreach($aPollsAddIds as $iPollId)
                $this->_oModule->_oDb->updatePolls(array($CNF['FIELD_POLL_CONTENT_ID'] => $iContentId), array($CNF['FIELD_POLL_ID'] => $iPollId, $CNF['FIELD_POLL_CONTENT_ID'] => 0));
        }

        return true;
    }

    protected function _getPhotoGhostTmplVars($aContentInfo = array())
    {
    	$CNF = &$this->_oModule->_oConfig->CNF;

    	return array (
            'name' => $this->aInputs[$CNF['FIELD_PHOTO']]['name'],
            'content_id' => (int)$this->aInputs[$CNF['FIELD_PHOTO']]['content_id'],
            'editor_id' => isset($CNF['FIELD_TEXT_ID']) ? $CNF['FIELD_TEXT_ID'] : ''
    	);
    }

    protected function _getVideoGhostTmplVars($aContentInfo = array())
    {
    	$CNF = &$this->_oModule->_oConfig->CNF;

    	return array (
            'name' => $this->aInputs[$CNF['FIELD_VIDEO']]['name'],
            'content_id' => (int)$this->aInputs[$CNF['FIELD_VIDEO']]['content_id'],
            'editor_id' => isset($CNF['FIELD_TEXT_ID']) ? $CNF['FIELD_TEXT_ID'] : ''
    	);
    }
}

/** @} */
