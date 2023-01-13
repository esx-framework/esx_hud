import TranslateData from '../assets/translate.json';

/**
 * Converts the key into dynamic language text
 * @param translateKey current translated string
 * @param translateObjectName current translate object name (Status,Speedo,Settings)
 * @param defaultKey (optional) return default string if doesn't exist key
 * @return {*}
 */
export const translate = (translateKey,translateObjectName = "General",defaultKey = null) =>{
    let currentLang = TranslateData.currentLang.length > 0 ? TranslateData.currentLang : "EN"
    if(!TranslateData[currentLang]){
        console.warn(`There is no such language type!  Current language type: ${currentLang}`)
        currentLang = "EN"
    }
    if(!TranslateData[currentLang][translateObjectName][translateKey.toLowerCase()]){
        console.warn(`Doesn't exist translate key: ${translateKey.toLowerCase()} in ${translateObjectName} translate object`)
        return defaultKey ? defaultKey : translateKey
    }
    return TranslateData[currentLang][translateObjectName][translateKey.toLowerCase()]
}