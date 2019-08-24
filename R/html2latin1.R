# from David Carlson, R-Help 8/12/2012
# Revised 8/22/2019 tohtml2latin1 to address possibility of no matches for Name or Number

#This may work for your needs with a little fine tuning. Special and accented
#characters can be represented in HTML with a character name or a numeric
#value. For example, " can be represented as &quot; or as &#034; and it
#appears from your example that both are used. I've included
#dput(HTMLChars) with the concordances. The
#following works on your data, but I haven't included any error checking.

#' Translate HTML entities to latin1 characters
#'
#' This function should be ammended to handles a few milestone encodings that aren't quite correct in the DB.
#'
#' @param txt A vector of character strings
#' @param A vector of character strings#'
#' @return A character vector, with HTML entities translated
#' @author David Carlson
#' @export
#' @examples
#' strings <- c("Fr&egrave;re de Montizon", "Lumi&egrave;re",
#'               "Ni&eacute;pce", "S&uuml;ssmilch", "Sch&uuml;pbach",
#'               "&#177; .25 &#215; 2 = &#189;")
#' html2latin1(strings)


html2latin1 <- function(txt) {
	# Search for &Name;
	lsta <- unique(unlist(regmatches(txt, gregexpr("&[[:alpha:]]+;", txt))))
	lsta <- data.frame(Name=lsta)
	matches <- merge(.HTMLChars, lsta)
	if(nrow(matches)) {
		for (i in 1:nrow(matches)) {
		     txt <- gsub(matches$Name[i], matches$Character[i], txt)
		}
	}

	# Search for &#Number;
	lstn <- unique(unlist(regmatches(txt, gregexpr("&#[[:digit:]]+;", txt))))
	lstn <- data.frame(Number=lstn)
	matches <- merge(.HTMLChars, lstn)
	if(nrow(matches)) {
		for (i in 1:nrow(matches)) {
			txt <- gsub(matches$Number[i], matches$Character[i], txt)
		}
	}

	# clean up some weird ones with bad encoding in the milestones DB
	txt <- gsub("&#39;", "'", txt)    # apostrophe, or &apos;
	txt <- gsub("&#65533;", "ä", txt) # &aul; -- only occurs in one place
	txt <- gsub("&#0233;", "é", txt)  # &eacute;

	txt
}

#' Translate latin1 characters to HTML entities
#'
#' @param txt A vector of character strings with latin1 characters
#' @return A character vector, with latin1 characters translated to HTML
#' @author David Carlson
#' @export
#' @examples
#' strings <- c("Frère de Montizon", "Lumière", "Niépce", "Süssmilch", "Schüpbach",
#'              "± .25 × 2 = ½")
#' latin12html(strings)

latin12html <- function(txt, type=c("name", "number")) {
	# Search for Character;
	chars <- paste(.HTMLChars[,1], collapse='|')
	lsta <- unique(unlist(regmatches(txt, chars)))
#	lsta <- data.frame(Name=lsta)
#	matches <- merge(HTMLChars, lsta)
	type <- match.arg(type)
	if (type=="name") {
  	  for (i in 1:nrow(.HTMLChars)) {
  	     txt <- gsub(.HTMLChars$Character[i], .HTMLChars$Name[i], txt)
  	}
	} else {
  	  for (i in 1:nrow(.HTMLChars)) {
  	     txt <- gsub(.HTMLChars$Character[i], .HTMLChars$Number[i], txt)
  	}
	}
	txt
}

# table of HTML characters, taken from David Carlson, R-Help 8/12/2012

.HTMLChars <-
  structure(list(Character = c("\"", "'", "&", "<", ">", "", "¡",
                               "¢", "£", "¤", "¥", "¦", "§", "¨", "©", "ª", "«", "¬", "--",
                               "®", "¯", "°", "±", "²", "³", "´", "µ", "¶", "·", "¸", "¹", "º",
                               "»", "¼", "½", "¾", "¿", "×", "÷", "À", "Á", "Â", "Ã", "Ä", "Å",
                               "Æ", "Ç", "È", "É", "Ê", "Ë", "Ì", "Í", "Î", "Ï", "Ð", "Ñ", "Ò",
                               "Ó", "Ô", "Õ", "Ö", "Ø", "Ù", "Ú", "Û", "Ü", "Ý", "Þ", "ß", "à",
                               "á", "â", "ã", "ä", "å", "æ", "ç", "è", "é", "ê", "ë", "ì", "í",
                               "î", "ï", "ð", "ñ", "ò", "ó", "ô", "õ", "ö", "ø", "ù", "ú", "û",
                               "ü", "ý", "þ"),
                 Number = c("&#034;", "&#039;", "&#038;", "&#060;",
                            "&#062;", "&#160;", "&#161;", "&#162;", "&#163;", "&#164;", "&#165;",
                            "&#166;", "&#167;", "&#168;", "&#169;", "&#170;", "&#171;", "&#172;",
                            "&#173;", "&#174;", "&#175;", "&#176;", "&#177;", "&#178;", "&#179;",
                            "&#180;", "&#181;", "&#182;", "&#183;", "&#184;", "&#185;", "&#186;",
                            "&#187;", "&#188;", "&#189;", "&#190;", "&#191;", "&#215;", "&#247;",
                            "&#192;", "&#193;", "&#194;", "&#195;", "&#196;", "&#197;", "&#198;",
                            "&#199;", "&#200;", "&#201;", "&#202;", "&#203;", "&#204;", "&#205;",
                            "&#206;", "&#207;", "&#208;", "&#209;", "&#210;", "&#211;", "&#212;",
                            "&#213;", "&#214;", "&#216;", "&#217;", "&#218;", "&#219;", "&#220;",
                            "&#221;", "&#222;", "&#223;", "&#224;", "&#225;", "&#226;", "&#227;",
                            "&#228;", "&#229;", "&#230;", "&#231;", "&#232;", "&#233;", "&#234;",
                            "&#235;", "&#236;", "&#237;", "&#238;", "&#239;", "&#240;", "&#241;",
                            "&#242;", "&#243;", "&#244;", "&#245;", "&#246;", "&#248;", "&#249;",
                            "&#250;", "&#251;", "&#252;", "&#253;", "&#254;"),
                 Name = c("&quot;",
                          "&apos;", "&amp;", "&lt;", "&gt;", "&nbsp;", "&iexcl;", "&cent;",
                          "&pound;", "&curren;", "&yen;", "&brvbar;", "&sect;", "&uml;",
                          "&copy;", "&ordf;", "&laquo;", "&not;", "&shy;", "&reg;", "&macr;",
                          "&deg;", "&plusmn;", "&sup2;", "&sup3;", "&acute;", "&micro;",
                          "&para;", "&middot;", "&cedil;", "&sup1;", "&ordm;", "&raquo;",
                          "&frac14;", "&frac12;", "&frac34;", "&iquest;", "&times;", "&divide;",
                          "&Agrave;", "&Aacute;", "&Acirc;", "&Atilde;", "&Auml;", "&Aring;",
                          "&AElig;", "&Ccedil;", "&Egrave;", "&Eacute;", "&Ecirc;", "&Euml;",
                          "&Igrave;", "&Iacute;", "&Icirc;", "&Iuml;", "&ETH;", "&Ntilde;",
                          "&Ograve;", "&Oacute;", "&Ocirc;", "&Otilde;", "&Ouml;", "&Oslash;",
                          "&Ugrave;", "&Uacute;", "&Ucirc;", "&Uuml;", "&Yacute;", "&THORN;",
                          "&szlig;", "&agrave;", "&aacute;", "&acirc;", "&atilde;", "&auml;",
                          "&aring;", "&aelig;", "&ccedil;", "&egrave;", "&eacute;", "&ecirc;",
                          "&euml;", "&igrave;", "&iacute;", "&icirc;", "&iuml;", "&eth;",
                          "&ntilde;", "&ograve;", "&oacute;", "&ocirc;", "&otilde;", "&ouml;",
                          "&oslash;", "&ugrave;", "&uacute;", "&ucirc;", "&uuml;", "&yacute;",
                          "&thorn;")), .Names = c("Character", "Number", "Name"),
            row.names = c(NA, 100L),
            class = "data.frame")
