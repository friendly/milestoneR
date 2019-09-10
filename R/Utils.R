library(data.table)
library(stringr)
library(DBI)
library(keyringr)
library(keyring)

# HTMLChars_v2 = fread("HTML Characters.csv")
# HTMLChars <-
#   structure(list(Character = c("\"", "'", "&", "<", ">", "", "ก",
#                                "ข", "ฃ", "ค", "ฅ", "ฆ", "ง", "จ", "ฉ", "ช", "ซ", "ฌ", "ญญ",
#                                "ฎ", "ฏ", "ฐ", "ฑ", "ฒ", "ณ", "ด", "ต", "ถ", "ท", "ธ", "น", "บ",
#                                "ป", "ผ", "ฝ", "พ", "ฟ", "ื", "๗", "ภ", "ม", "ย", "ร", "ฤ", "ล",
#                                "ฦ", "ว", "ศ", "ษ", "ส", "ห", "ฬ", "อ", "ฮ", "ฯ", "ะ", "ั", "า",
#                                "ำ", "ิ", "ี", "ึ", "ุ", "ู", "ฺ", "", "", "", "", "฿", "เ",
#                                "แ", "โ", "ใ", "ไ", "ๅ", "ๆ", "็", "่", "้", "๊", "๋", "์", "ํ",
#                                "๎", "๏", "๐", "๑", "๒", "๓", "๔", "๕", "๖", "๘", "๙", "๚", "๛",
#                                "", "", ""), Number = c("&#034;", "&#039;", "&#038;", "&#060;",
#                                                           "&#062;", "&#160;", "&#161;", "&#162;", "&#163;", "&#164;", "&#165;",
#                                                           "&#166;", "&#167;", "&#168;", "&#169;", "&#170;", "&#171;", "&#172;",
#                                                           "&#173;", "&#174;", "&#175;", "&#176;", "&#177;", "&#178;", "&#179;",
#                                                           "&#180;", "&#181;", "&#182;", "&#183;", "&#184;", "&#185;", "&#186;",
#                                                           "&#187;", "&#188;", "&#189;", "&#190;", "&#191;", "&#215;", "&#247;",
#                                                           "&#192;", "&#193;", "&#194;", "&#195;", "&#196;", "&#197;", "&#198;",
#                                                           "&#199;", "&#200;", "&#201;", "&#202;", "&#203;", "&#204;", "&#205;",
#                                                           "&#206;", "&#207;", "&#208;", "&#209;", "&#210;", "&#211;", "&#212;",
#                                                           "&#213;", "&#214;", "&#216;", "&#217;", "&#218;", "&#219;", "&#220;",
#                                                           "&#221;", "&#222;", "&#223;", "&#224;", "&#225;", "&#226;", "&#227;",
#                                                           "&#228;", "&#229;", "&#230;", "&#231;", "&#232;", "&#233;", "&#234;",
#                                                           "&#235;", "&#236;", "&#237;", "&#238;", "&#239;", "&#240;", "&#241;",
#                                                           "&#242;", "&#243;", "&#244;", "&#245;", "&#246;", "&#248;", "&#249;",
#                                                           "&#250;", "&#251;", "&#252;", "&#253;", "&#254;"), Name = c("&quot;",
#                                                                                                                       "&apos;", "&amp;", "&lt;", "&gt;", "&nbsp;", "&iexcl;", "&cent;",
#                                                                                                                       "&pound;", "&curren;", "&yen;", "&brvbar;", "&sect;", "&uml;",
#                                                                                                                       "&copy;", "&ordf;", "&laquo;", "&not;", "&shy;", "&reg;", "&macr;",
#                                                                                                                       "&deg;", "&plusmn;", "&sup2;", "&sup3;", "&acute;", "&micro;",
#                                                                                                                       "&para;", "&middot;", "&cedil;", "&sup1;", "&ordm;", "&raquo;",
#                                                                                                                       "&frac14;", "&frac12;", "&frac34;", "&iquest;", "&times;", "&divide;",
#                                                                                                                       "&Agrave;", "&Aacute;", "&Acirc;", "&Atilde;", "&Auml;", "&Aring;",
#                                                                                                                       "&AElig;", "&Ccedil;", "&Egrave;", "&Eacute;", "&Ecirc;", "&Euml;",
#                                                                                                                       "&Igrave;", "&Iacute;", "&Icirc;", "&Iuml;", "&ETH;", "&Ntilde;",
#                                                                                                                       "&Ograve;", "&Oacute;", "&Ocirc;", "&Otilde;", "&Ouml;", "&Oslash;",
#                                                                                                                       "&Ugrave;", "&Uacute;", "&Ucirc;", "&Uuml;", "&Yacute;", "&THORN;",
#                                                                                                                       "&szlig;", "&agrave;", "&aacute;", "&acirc;", "&atilde;", "&auml;",
#                                                                                                                       "&aring;", "&aelig;", "&ccedil;", "&egrave;", "&eacute;", "&ecirc;",
#                                                                                                                       "&euml;", "&igrave;", "&iacute;", "&icirc;", "&iuml;", "&eth;",
#                                                                                                                       "&ntilde;", "&ograve;", "&oacute;", "&ocirc;", "&otilde;", "&ouml;",
#                                                                                                                       "&oslash;", "&ugrave;", "&uacute;", "&ucirc;", "&uuml;", "&yacute;",
#                                                                                                                       "&thorn;")), .Names = c("Character", "Number", "Name"), row.names = c(NA,
#                                                                                                                                                                                             100L), class = "data.frame")


#This may work for your needs with a little fine tuning. Special and accented
#characters can be represented in HTML with a character name or a numeric
#value. For example, " can be represented as &quot; or as &#034; and it
#appears from your example that both are used. I've attached a
#dput(HTMLChars) to the end of this message with the concordances. The
#following works on your data, but I haven't included any error checking.
#Assuming your .csv file is called txt and the data.frame HTMLChars is
#loaded:
HTMLChars = as.data.table(HTMLChars_v2)

html2latin1 <- function(txt_orig) {
  if (shiny::isTruthy(txt_orig)) {
    # Search for &Name;
    matches = HTMLChars[str_detect(txt_orig, Name) == TRUE, .(Match = 1, Character),by = 'Name'][Match == 1]
    if (nrow(matches) > 0) {
      replacements = setNames(as.character(matches$Character), matches$Name)
      txt <- str_replace_all(txt_orig, replacements)
    }

    if (!exists('txt')) {
      txt = txt_orig
    } else {
      txt = txt
    }

    # Search for &#Number;
    matches_num = HTMLChars[str_detect(txt_orig, Number) == TRUE, .(Match = 1, Character),by = 'Number'][Match == 1]
    if (nrow(matches_num) > 0) {
      replacements_num = setNames(as.character(matches_num$Character), matches_num$Number)
      txt <- str_replace_all(txt, replacements_num)
    }
    if (nrow(matches) == 0 & nrow(matches_num) == 0) {
      txt = txt_orig
    }
    return(txt)
  } else {
    return ('')
  }
}

latin12html <- function(txt, type=c("name", "number")) {
  # Search for Character;
  chars <- paste(HTMLChars[,1], collapse='|')
  lsta <- unique(unlist(regmatches(txt, chars)))
  #	lsta <- data.frame(Name=lsta)
  #	matches <- merge(HTMLChars, lsta)
  type <- match.arg(type)
  if (type=="name") {
    for (i in 1:nrow(HTMLChars)) {
      txt <- gsub(HTMLChars$Character[i], HTMLChars$Name[i], txt)
    }
  } else {
    for (i in 1:nrow(HTMLChars)) {
      txt <- gsub(HTMLChars$Character[i], HTMLChars$Number[i], txt)
    }
  }
  txt
}

get_os <- function(){
  sysinf <- Sys.info()
  if (!is.null(sysinf)){
    os <- sysinf['sysname']
    if (os == 'Darwin')
      os <- "osx"
  } else { ## mystery machine
    os <- .Platform$OS.type
    if (grepl("^darwin", R.version$os))
      os <- "osx"
    if (grepl("linux-gnu", R.version$os))
      os <- "linux"
  }
  tolower(os)[[1]]
}
