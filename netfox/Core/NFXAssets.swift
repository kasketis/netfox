//
//  NFXAssets.swift
//  netfox
//
//  Copyright © 2016 netfox. All rights reserved.
//

import Foundation

enum NFXAssetName {
    case settings
    case info
    case statistics
}

class NFXAssets
{
    class func getImage(_ image: NFXAssetName) -> Data
    {
        var base64Image: String

        switch image {
        case .settings:
            base64Image = getSettingsImageBase64()
            break
        case .info:
            base64Image = getInfoImageBase64()
            break
        case .statistics:
            base64Image = getStatisticsImageBase64()
            break
        }
        
        if let imageData = Data(base64Encoded: base64Image, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters) {
            return imageData
        } else {
            return Data()
        }
    }
    
    
    class func getSettingsImageBase64() -> String
    {
        return "iVBORw0KGgoAAAANSUhEUgAAACwAAAAsCAMAAAApWqozAAAAjVBMVEUAAADsXijtXSfsXSftXijsXibsXSftXibtXSftXijtXSftXSXtXijtXijtXibtXSftXSfsXijsXSfuXSbsXijtXiftXSfuXSbtXijsXSjsXSjsXSjsXSftXSbsXSftXijtXibtXSftXSbuXSXtXSfsXifsXSftXibtXibsXSjtXSjtXSbtXyXtXibsXigoILJHAAAALnRSTlMA+wPDvSDAgdqtlhUH1GpRGOnIk/j0XS7vz6mkdR0PtJw7MguQZFl8VuzMRSaGMJ3GQwAAAi5JREFUOMulVdm2ojAQTEJYZRcQBBQVl+tS//95MwGDAQev50xeslWS7upONXlvfp4kNMkz8k1bo9A0D85XYC8/ELKh2jfYBb12R9LDPGa5ZP1gh1J0Nvb93F2WbIoFilU3CnAWnYmgm648wJ5iuQNaiU3eoy7g4rBPseRYq1gHhksuCZyTBli6WNItgAct6IW4HPbLklZgu0sBO9j0i5tgC8D4a7lAlwP4Id9Z2nf1wdXWkdQ/Xqsc/ic2fXCV2xSreewK6UKdZyjYLLjAacqdmguuO6KqnZy+YSuHuqlFkXbW5VzDbgK+Qm5WACwLQPVc2MMYY/UhpA1Sv2as9lM0w9XhAGTh7mjg1k9MGIsnQwZM6f022y2YeLW0IB7uE7LGz2Lg8wd1NwgjANQrKwL8XMvqEsqLj2RoR3m1fjqX1xwgSbFRbI+pQn9IY2VrUyRk9H3cyFLdtiKVb40SanwLNihJvJCpZoQzZrDQS4jw0z7/5qBpexQgxzZOX9Tps9SlWpt1fu6z34Jy2iuc3Ydwl8jfw70goxZ/SiT+IUXP4xSN31K0QTuf/M70S37QwRjHUTrTVJ8H3ylVdlmBgHxoJ+U7s8HgZkZkHDRMgh1wEcDdtZOvgypfsWDiwLFmqjAy4gNmEANePQjj7QH4hElhHGTDWCPKRAiMkeRmOdZSchU0eP30plLFXDekmKtok8gy0YzKBDHLeWULEcsC9FVpc2Vp+/+iOS3H9N/l+A8JizxgzuMcJQAAAABJRU5ErkJggg=="
    }
    
    class func getInfoImageBase64() -> String
    {
        return "iVBORw0KGgoAAAANSUhEUgAAACwAAAAsCAMAAAApWqozAAAAb1BMVEUAAADsXijsXijsXCbtXCfsXijsXijsXijsXijsXifsXijsXifsXijsXijsXijsXSfsXijsXSjsXijsXijsXijsXijsXijsXifsXSjsXiftXSfsXijsXSfsXSbsXijsXijsXijsXijtXifsXSjsXihHY9oeAAAAJHRSTlMA+mMTBO/VUeM3CqHe9KwOmj/nx7ymmJF7a1s4MyabRN1nG4QDLG4nAAABaklEQVQ4y5WV626DMAyFHXInhDuMcm07v/8zTt0mNEiykvPT+mQ5ju0DR7FUD7moEWuRDzplEBadeoKEq7sQd8UJkn6iAbSQLdpmTWbKABidk7Wx2MrCx+oOeSkPmagsOXbaZW8KTeXUyCqD6naOfhA+puBROnLycQwZzBYIaMnQHPKioBAUFfgn941kO+ulM7LXrRVf4F8tXOnf/nY4whuN2P30W6I59aEyZjv1xKD8LqjlFRz1QPw8hSreUgCYsGTvYVbiBMB6K53Xb9vzHJO2Z5CShsIF0YanoHGFS1pRw0ASJ/6U8ukEEzJAzmdP3JNh5jkIRa/BVAmo7+wazLIaUMA1GARGwVFlRD0wrnUDSUKw+yka12vwitoZpBBMG5vuI+rC7ojuw+/A7vAH1+rhWSv/wm557lnYwClgRcHcUxBzZGLOV8xhjDm5Mcc82ibiDShsbeVubQHTtC/TzITIXqZpHdOMsOMvY4Ib6juEh/AAAAAASUVORK5CYII="
    }
    
    class func getStatisticsImageBase64() -> String
    {
        return "iVBORw0KGgoAAAANSUhEUgAAACwAAAAsCAMAAAApWqozAAAAflBMVEUAAADsXijsXijsXijsXijtXSfsXijsXSjsXijsXijsXSbsXijtXSjsXijsXifsXijsXiftXifsXifsXCfsXifsXifsXifsXifsXSftXSfsWyjsXijsXifsXifsXijtXifsXiftXybsXSfsXijtXSftXifsWibsXijuYCfsXijgd1NoAAAAKXRSTlMANNuwVBbuh/CUA9UG+t/QvCz0D+jYy3RKOQrlxqmOgGUgv7VvVwxbHXzMYTYAAAEjSURBVDjL7ZRJcoMwEEVlEgkhMU8GzOgp+fe/YChXxQSqK27vvPBbQfdbSD1IkMSxYONb6/Nta+n4B4XWZFjgCQTCZMciCWfZEUyctzzTDH3GlgfgSMmTCuXWlREQUXILbIcz0UijiZC/AiC4/FXNgOBMXdCckI4jEPvLYLdId1Q1pgOi+dZZhDRZjlASpfO7MsXZv32OCNxbdh9gT9U5BoLqN1orlNI0HnRNNiUHvCUsj8htiJOkO/gdlauMi3sRiXabTSc0ULFnI2kvLzaiLyjn1SeLKsdzb92OoA7DmooLClMURnDxAI/ruphxua4+HDTP9qAyazMFj+VK4zhGMmwXqplXdV7URsF96Mr7tjywe6jr8ndV6P+Ru0KuNrHoVukfuacsKwHjtUEAAAAASUVORK5CYII="
    }
    
}
