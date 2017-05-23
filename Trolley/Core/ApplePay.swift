//
//  ApplePay.swift
//  Pods
//
//  Created by Harry Wright on 13.04.17.
//
//

import Foundation
//import MapKit
import PassKit

let SupportedPaymentNetworks: [PKPaymentNetwork] = [.visa, .masterCard, .amex]

let applePayMerchantId: String = ""

struct SummaryItem<Cost: MoneyType> {
    
    var amount: Cost
    
    var label: String
    
    init(amount: Cost, label: String) {
        self.label = label
        self.amount = amount
    }
    
}

typealias PaymentSummaryItem = SummaryItem<Money>

internal extension PKPaymentSummaryItem {
    
    convenience init<Cost: MoneyType>(summaryItem: SummaryItem<Cost>) {
        self.init(label: summaryItem.label, amount: summaryItem.amount.decimalValue)
    }
    
}

public extension PKPaymentRequest {
    
    convenience init(basket: Basket, sellerName: String) {
        self.init()
        
        currencyCode = basket.total.currency.code
        
        var items = [PaymentSummaryItem]()
        basket.forEach {
            items.append(SummaryItem(amount: $0.total, label: $0.name))
        }
        
        let total = items.map{ $0.amount }.reduce(0, +)
        items.append(SummaryItem(amount: total, label: sellerName))
        paymentSummaryItems = items.map { PKPaymentSummaryItem(summaryItem: $0) }
    }
    
}

func setupRequest(
    for basket: Basket,
    with sellerName: String,
    PaymentNetworks: [PKPaymentNetwork] = SupportedPaymentNetworks
    ) -> PKPaymentRequest
{
    let request = PKPaymentRequest(basket: basket, sellerName: sellerName)
    request.supportedNetworks = PaymentNetworks
    return request
}

