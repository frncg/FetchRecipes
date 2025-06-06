//
//  Cache.swift
//  FetchTakeHome
//
//  Created by Franco Miguel Guevarra on 6/3/25.
//

import Foundation

final class Cache<V> {
    
    fileprivate let cache: NSCache<NSString, CacheEntry<V>>
    
    init(countLimit: Int = 100, totalCostLimit: Int = 100_000_000) {
        self.cache = NSCache<NSString, CacheEntry<V>>()
        self.cache.countLimit = countLimit
        self.cache.totalCostLimit = totalCostLimit
    }
        
    subscript(_ key: String) -> V? {
        get { value(forKey: key) }
        set { setValue(newValue, forKey: key)}
    }
    
    func setValue(_ value: V?, forKey key: String) {
        if let value = value {
            let cacheEntry = CacheEntry(key: key, value: value)
            cache.setObject(cacheEntry, forKey: key as NSString)
        } else {
            removeValue(forKey: key)
        }
    }
    
    func value(forKey key: String) -> V? {
        guard let entry = cache.object(forKey: key as NSString) else {
            return nil
        }
        
        return entry.value
    }
    
    func removeValue(forKey key: String) {
        cache.removeObject(forKey: key as NSString)
    }
    
    func removeAllValues() {
        cache.removeAllObjects()
    }
}

final class CacheEntry<V> {
    
    let key: String
    let value: V
    
    init(key: String, value: V) {
        self.key = key
        self.value = value
    }
    
}
