<?php defined('BX_DOL') or die('hack attempt');
/**
 * Copyright (c) UNA, Inc - https://una.io
 * MIT License - https://opensource.org/licenses/MIT
 *
 * @defgroup    Organizations Organizations
 * @ingroup     UnaModules
 *
 * @{
 */

class BxOrgsAlertsResponse extends BxBaseModProfileAlertsResponse
{
    public function __construct()
    {
    	$this->MODULE = 'bx_organizations';
        parent::__construct();
    }
}

/** @} */
