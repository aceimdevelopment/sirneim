/*
 * Copyright (c) 2008 Greg Weber greg at gregweber.info
 * Dual licensed under the MIT and GPLv2 licenses just as jQuery is:
 * http://jquery.org/license
 *
 * documentation at http://gregweber.info/projects/uitablefilter
 *
 * allows table rows to be filtered (made invisible)
 * <code>
 * t = $('table')
 * $.uiTableFilter( t, phrase )
 * </code>
 * arguments:
 *   jQuery object containing table rows
 *   phrase to search for
 *   optional arguments:
 *     column to limit search too (the column title in the table header)
 *     ifHidden - callback to execute if one or more elements was hidden
 */
(function(a){a.uiTableFilter=function(b,c,d,e){var f=!1;if(this.last_phrase===c)return!1;var g=c.length,h=c.toLowerCase().split(" "),i=function(a){a.show()},j=function(a){a.hide(),f=!0},k=function(a){return a.text()};if(d){var l=null;b.find("thead > tr:last > th").each(function(b){if(a.trim(a(this).text())==d)return l=b,!1});if(l==null)throw"given column: "+d+" not found";k=function(b){return a(b.find("td:eq("+l+")")).text()}}if(h.size>1&&c.substr(0,g-1)===this.last_phrase){if(c[-1]===" ")return this.last_phrase=c,!1;var h=h[-1];i=function(a){};var m=b.find("tbody:first > tr:visible")}else{f=!0;var m=b.find("tbody:first > tr")}return m.each(function(){var b=a(this);a.uiTableFilter.has_words(k(b),h,!1)?i(b):j(b)}),last_phrase=c,e&&f&&e(),b},a.uiTableFilter.last_phrase="",a.uiTableFilter.has_words=function(a,b,c){var d=c?a:a.toLowerCase();for(var e=0;e<b.length;e++)if(d.indexOf(b[e])===-1)return!1;return!0}})(jQuery)