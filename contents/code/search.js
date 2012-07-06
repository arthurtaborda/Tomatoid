/**

    Copyright (C) 2011 Glad Deschrijver <glad.deschrijver@gmail.com>

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, see <http://www.gnu.org/licenses/>.

*/

var searchEntries;
var searchNames;
var searchListTmp;
var searchI;
var searchString;

function initialize(text) {
	searchEntries = appsSource.connectedSources;
	searchNames = new Array();
	searchListTmp = new Array();
	searchI = 0;
	searchString = text;
}

function search() {
	for (var j = 0; j < 5; j++) { // waste less time in the intervals (of 1ms which in reality is 16ms according to the Qt doc) between two triggers of searchTimer
		var entry = appsSource.data[searchEntries[searchI]];
		if (searchEntries[searchI] != "---" && entry["isApp"] && searchNames.indexOf(entry["name"]) < 0
		    && (searchEntries[searchI].substring(0, searchEntries[searchI].length - 8).toLowerCase().indexOf(searchString) >= 0 // don't match the extension ".desktop"
		    || entry["genericName"].toLowerCase().indexOf(searchString) >= 0
		    || entry["comment"].toLowerCase().indexOf(searchString) >= 0)) {
			searchNames.push(entry["name"]);
			searchListTmp.push([searchEntries[searchI], entry["name"], entry["genericName"], entry["iconName"], entry["isApp"], false]);
		}
		searchI++;
		if (searchI == searchEntries.length)
			return false;
	}
	return true;
}
