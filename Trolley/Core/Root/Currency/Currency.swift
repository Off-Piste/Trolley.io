//
//  Currency.swift
//  Pods
//
//  Created by Harry Wright on 31.03.17.
//
//

import Foundation

@objc(TRLCurrencyCode)
public enum Currency: Int {
    
    case AED = 0
    case AFN
    case ALL
    case AMD
    case ANG
    case AOA
    case ARS
    case AUD
    case AWG
    case AZN
    case BAM
    case BBD
    case BDT
    case BGN
    case BHD
    case BIF
    case BMD
    case BND
    case BOB
    case BRL
    case BSD
    case BWP
    case BYR
    case BZD
    case CAD
    case CHF
    case CLP
    case CNY
    case COP
    case CRC
    case CUP
    case CVE
    case CZK
    case DJF
    case DKK
    case DOP
    case DZD
    case EGP
    case ERN
    case ETB
    case EUR
    case FJD
    case FKP
    case GBP
    case GEL
    case GHS
    case GIP
    case GMD
    case GNF
    case GTQ
    case GYD
    case HKD
    case HNL
    case HRK
    case HUF
    case IDR
    case ILS
    case INR
    case IQD
    case IRR
    case ISK
    case JMD
    case JOD
    case JPY
    case KES
    case KGS
    case KHR
    case KMF
    case KPW
    case KRW
    case KWD
    case KYD
    case KZT
    case LAK
    case LBP
    case LKR
    case LRD
    case LYD
    case MAD
    case MDL
    case MGA
    case MKD
    case MMK
    case MNT
    case MOP
    case MRO
    case MUR
    case MVR
    case MWK
    case MXN
    case MYR
    case MZN
    case NGN
    case NIO
    case NOK
    case NPR
    case NZD
    case OMR
    case PEN
    case PGK
    case PHP
    case PKR
    case PLN
    case PYG
    case QAR
    case RON
    case RSD
    case RUB
    case RWF
    case SAR
    case SBD
    case SCR
    case SDG
    case SEK
    case SGD
    case SHP
    case SLL
    case SOS
    case SRD
    case SSP
    case STD
    case SYP
    case SZL
    case THB
    case TJS
    case TMT
    case TND
    case TOP
    case TRY
    case TTD
    case TWD
    case TZS
    case UAH
    case UGX
    case USD
    case UYU
    case UZS
    case VEF
    case VND
    case VUV
    case WST
    case XAF
    case XCD
    case XOF
    case XPF
    case YER
    case ZAR
    case ZMW
    case ZWL
    
}

public extension Currency {
    
    init(localeIdentifier: String) {
        switch localeIdentifier {
        case "AED": self = .AED
        case "AFN": self = .AFN
        case "ALL": self = .ALL
        case "AMD": self = .AMD
        case "ANG": self = .ANG
        case "AOA": self = .AOA
        case "ARS": self = .ARS
        case "AUD": self = .AUD
        case "AWG": self = .AWG
        case "AZN": self = .AZN
        case "BAM": self = .BAM
        case "BBD": self = .BBD
        case "BDT": self = .BDT
        case "BGN": self = .BGN
        case "BHD": self = .BHD
        case "BIF": self = .BIF
        case "BMD": self = .BMD
        case "BND": self = .BND
        case "BOB": self = .BOB
        case "BRL": self = .BRL
        case "BSD": self = .BSD
        case "BWP": self = .BWP
        case "BYR": self = .BYR
        case "BZD": self = .BZD
        case "CAD": self = .CAD
        case "CHF": self = .CHF
        case "CLP": self = .CLP
        case "CNY": self = .CNY
        case "COP": self = .COP
        case "CRC": self = .CRC
        case "CUP": self = .CUP
        case "CVE": self = .CVE
        case "CZK": self = .CZK
        case "DJF": self = .DJF
        case "DKK": self = .DKK
        case "DOP": self = .DOP
        case "DZD": self = .DZD
        case "EGP": self = .EGP
        case "ERN": self = .ERN
        case "ETB": self = .ETB
        case "EUR": self = .EUR
        case "FJD": self = .FJD
        case "FKP": self = .FKP
        case "GBP": self = .GBP
        case "GEL": self = .GEL
        case "GHS": self = .GHS
        case "GIP": self = .GIP
        case "GMD": self = .GMD
        case "GNF": self = .GNF
        case "GTQ": self = .GTQ
        case "GYD": self = .GYD
        case "HKD": self = .HKD
        case "HNL": self = .HNL
        case "HRK": self = .HRK
        case "HUF": self = .HUF
        case "IDR": self = .IDR
        case "ILS": self = .ILS
        case "INR": self = .INR
        case "IQD": self = .IQD
        case "IRR": self = .IRR
        case "ISK": self = .ISK
        case "JMD": self = .JMD
        case "JOD": self = .JOD
        case "JPY": self = .JPY
        case "KES": self = .KES
        case "KGS": self = .KGS
        case "KHR": self = .KHR
        case "KMF": self = .KMF
        case "KPW": self = .KPW
        case "KRW": self = .KRW
        case "KWD": self = .KWD
        case "KYD": self = .KYD
        case "KZT": self = .KZT
        case "LAK": self = .LAK
        case "LBP": self = .LBP
        case "LKR": self = .LKR
        case "LRD": self = .LRD
        case "LYD": self = .LYD
        case "MAD": self = .MAD
        case "MDL": self = .MDL
        case "MGA": self = .MGA
        case "MKD": self = .MKD
        case "MMK": self = .MMK
        case "MNT": self = .MNT
        case "MOP": self = .MOP
        case "MRO": self = .MRO
        case "MUR": self = .MUR
        case "MVR": self = .MVR
        case "MWK": self = .MWK
        case "MXN": self = .MXN
        case "MYR": self = .MYR
        case "MZN": self = .MZN
        case "NGN": self = .NGN
        case "NIO": self = .NIO
        case "NOK": self = .NOK
        case "NPR": self = .NPR
        case "NZD": self = .NZD
        case "OMR": self = .OMR
        case "PEN": self = .PEN
        case "PGK": self = .PGK
        case "PHP": self = .PHP
        case "PKR": self = .PKR
        case "PLN": self = .PLN
        case "PYG": self = .PYG
        case "QAR": self = .QAR
        case "RON": self = .RON
        case "RSD": self = .RSD
        case "RUB": self = .RUB
        case "RWF": self = .RWF
        case "SAR": self = .SAR
        case "SBD": self = .SBD
        case "SCR": self = .SCR
        case "SDG": self = .SDG
        case "SEK": self = .SEK
        case "SGD": self = .SGD
        case "SHP": self = .SHP
        case "SLL": self = .SLL
        case "SOS": self = .SOS
        case "SRD": self = .SRD
        case "SSP": self = .SSP
        case "STD": self = .STD
        case "SYP": self = .SYP
        case "SZL": self = .SZL
        case "THB": self = .THB
        case "TJS": self = .TJS
        case "TMT": self = .TMT
        case "TND": self = .TND
        case "TOP": self = .TOP
        case "TRY": self = .TRY
        case "TTD": self = .TTD
        case "TWD": self = .TWD
        case "TZS": self = .TZS
        case "UAH": self = .UAH
        case "UGX": self = .UGX
        case "USD": self = .USD
        case "UYU": self = .UYU
        case "UZS": self = .UZS
        case "VEF": self = .VEF
        case "VND": self = .VND
        case "VUV": self = .VUV
        case "WST": self = .WST
        case "XAF": self = .XAF
        case "XCD": self = .XCD
        case "XOF": self = .XOF
        case "XPF": self = .XPF
        case "YER": self = .YER
        case "ZAR": self = .ZAR
        case "ZMW": self = .ZMW
        case "ZWL": self = .ZWL
        default: self = .GBP
        }
    }
    
    public var description: String{
        get{
            switch self {
            case .AED: return "AED"
            case .AFN: return "AFN"
            case .ALL: return "ALL"
            case .AMD: return "AMD"
            case .ANG: return "ANG"
            case .AOA: return "AOA"
            case .ARS: return "ARS"
            case .AUD: return "AUD"
            case .AWG: return "AWG"
            case .AZN: return "AZN"
            case .BAM: return "BAM"
            case .BBD: return "BBD"
            case .BDT: return "BDT"
            case .BGN: return "BGN"
            case .BHD: return "BHD"
            case .BIF: return "BIF"
            case .BMD: return "BMD"
            case .BND: return "BND"
            case .BOB: return "BOB"
            case .BRL: return "BRL"
            case .BSD: return "BSD"
            case .BWP: return "BWP"
            case .BYR: return "BYR"
            case .BZD: return "BZD"
            case .CAD: return "CAD"
            case .CHF: return "CHF"
            case .CLP: return "CLP"
            case .CNY: return "CNY"
            case .COP: return "COP"
            case .CRC: return "CRC"
            case .CUP: return "CUP"
            case .CVE: return "CVE"
            case .CZK: return "CZK"
            case .DJF: return "DJF"
            case .DKK: return "DKK"
            case .DOP: return "DOP"
            case .DZD: return "DZD"
            case .EGP: return "EGP"
            case .ERN: return "ERN"
            case .ETB: return "ETB"
            case .EUR: return "EUR"
            case .FJD: return "FJD"
            case .FKP: return "FKP"
            case .GBP: return "GBP"
            case .GEL: return "GEL"
            case .GHS: return "GHS"
            case .GIP: return "GIP"
            case .GMD: return "GMD"
            case .GNF: return "GNF"
            case .GTQ: return "GTQ"
            case .GYD: return "GYD"
            case .HKD: return "HKD"
            case .HNL: return "HNL"
            case .HRK: return "HRK"
            case .HUF: return "HUF"
            case .IDR: return "IDR"
            case .ILS: return "ILS"
            case .INR: return "INR"
            case .IQD: return "IQD"
            case .IRR: return "IRR"
            case .ISK: return "ISK"
            case .JMD: return "JMD"
            case .JOD: return "JOD"
            case .JPY: return "JPY"
            case .KES: return "KES"
            case .KGS: return "KGS"
            case .KHR: return "KHR"
            case .KMF: return "KMF"
            case .KPW: return "KPW"
            case .KRW: return "KRW"
            case .KWD: return "KWD"
            case .KYD: return "KYD"
            case .KZT: return "KZT"
            case .LAK: return "LAK"
            case .LBP: return "LBP"
            case .LKR: return "LKR"
            case .LRD: return "LRD"
            case .LYD: return "LYD"
            case .MAD: return "MAD"
            case .MDL: return "MDL"
            case .MGA: return "MGA"
            case .MKD: return "MKD"
            case .MMK: return "MMK"
            case .MNT: return "MNT"
            case .MOP: return "MOP"
            case .MRO: return "MRO"
            case .MUR: return "MUR"
            case .MVR: return "MVR"
            case .MWK: return "MWK"
            case .MXN: return "MXN"
            case .MYR: return "MYR"
            case .MZN: return "MZN"
            case .NGN: return "NGN"
            case .NIO: return "NIO"
            case .NOK: return "NOK"
            case .NPR: return "NPR"
            case .NZD: return "NZD"
            case .OMR: return "OMR"
            case .PEN: return "PEN"
            case .PGK: return "PGK"
            case .PHP: return "PHP"
            case .PKR: return "PKR"
            case .PLN: return "PLN"
            case .PYG: return "PYG"
            case .QAR: return "QAR"
            case .RON: return "RON"
            case .RSD: return "RSD"
            case .RUB: return "RUB"
            case .RWF: return "RWF"
            case .SAR: return "SAR"
            case .SBD: return "SBD"
            case .SCR: return "SCR"
            case .SDG: return "SDG"
            case .SEK: return "SEK"
            case .SGD: return "SGD"
            case .SHP: return "SHP"
            case .SLL: return "SLL"
            case .SOS: return "SOS"
            case .SRD: return "SRD"
            case .SSP: return "SSP"
            case .STD: return "STD"
            case .SYP: return "SYP"
            case .SZL: return "SZL"
            case .THB: return "THB"
            case .TJS: return "TJS"
            case .TMT: return "TMT"
            case .TND: return "TND"
            case .TOP: return "TOP"
            case .TRY: return "TRY"
            case .TTD: return "TTD"
            case .TWD: return "TWD"
            case .TZS: return "TZS"
            case .UAH: return "UAH"
            case .UGX: return "UGX"
            case .USD: return "USD"
            case .UYU: return "UYU"
            case .UZS: return "UZS"
            case .VEF: return "VEF"
            case .VND: return "VND"
            case .VUV: return "VUV"
            case .WST: return "WST"
            case .XAF: return "XAF"
            case .XCD: return "XCD"
            case .XOF: return "XOF"
            case .XPF: return "XPF"
            case .YER: return "YER"
            case .ZAR: return "ZAR"
            case .ZMW: return "ZMW"
            case .ZWL: return "ZWL"
            }
        }
    }
    
    /// <#Description#>
    public var code: String {
        return self.description
    }
    
    /// <#Description#>
    public var conversionRate: NSDecimalNumber {
        return CurrencyConverter.shared.decimalRate
    }
    
    /// <#Description#>
    ///
    /// - Parameter value: <#value description#>
    /// - Returns: <#return value description#>
    public func convert(value: NSDecimalNumber) -> NSDecimalNumber {
        return CurrencyConverter.shared.convert(value: value)
    }
}
