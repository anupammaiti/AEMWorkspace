/*************************************************************************
 *
 * ADOBE CONFIDENTIAL
 * __________________
 *
 *  Copyright 2013 Adobe Systems Incorporated
 *  All Rights Reserved.
 *
 * NOTICE:  All information contained herein is, and remains
 * the property of Adobe Systems Incorporated and its suppliers,
 * if any.  The intellectual and technical concepts contained
 * herein are proprietary to Adobe Systems Incorporated and its
 * suppliers and are protected by trade secret or copyright law.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Adobe Systems Incorporated.
 **************************************************************************/
(function($) {
   $(function(){
       var $navigatorDisplayLink = $('.title-and-navigation-div .navigation-menu-link');
       $navigatorDisplayLink.click(function() {
           var $menu = $(this).closest('.title-and-navigation-div').find('.messagebox-navigation-menu-top');
           if ($menu.is(":visible")) {
               $menu.hide();
           } else {
               $menu.show();
           }
       });
   });
})($CQ || jQuery);