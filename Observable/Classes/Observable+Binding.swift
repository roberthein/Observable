//
// Observable+Binding.swift
// Observable
//
// Created by bfrolicher on 20/07/2020.
//
import Foundation

public extension Observable {
    
    /// Bind wrappedValue to `objectKeyPath` property of type `T` in object `O`
    ///
    /// - Parameter object: Owner of the property
    /// - Parameter objectKeyPath: Keypath property
    /// - Parameter disposal: Observable container
    ///
    /// Sample :
    ///
    /// ```
    /// class SomeViewModel {
    ///     var username =  Observable("")
    /// }
    ///
    /// class ViewController {
    ///     self.viewModel.username.bind(to: self.usernameLabel, \.text, disposal: &self.disposal)
    /// }
    ///
    /// ```
    ///
    func bind<O>(to object: O, _ objectKeyPath: ReferenceWritableKeyPath<O, T>, disposal: inout Disposal) {
        self.observe { [weak self] (new, old) in
            guard let strongSelf = self else { return }
            object[keyPath: objectKeyPath] = strongSelf.wrappedValue
        }.add(to: &disposal)
    }
    
    
    /// Bind **optional** wrappedValue to `objectKeyPath` property of type `T` in object `O`
    ///
    /// - Parameter object: Owner of the property
    /// - Parameter objectKeyPath: Keypath property
    /// - Parameter disposal: Observable container
    ///
    /// Sample :
    ///
    /// ```
    /// class SomeViewModel {
    ///     var username =  Observable("")
    /// }
    ///
    /// class ViewController {
    ///     self.viewModel.username.bind(to: self.usernameLabel, \.text, disposal: &self.disposal)
    /// }
    ///
    /// ```
    ///
    func bind<O>(to object: O, _ objectKeyPath: ReferenceWritableKeyPath<O, T?>, disposal: inout Disposal) {
        self.observe { [weak self] (new, old) in
            guard let strongSelf = self else { return }
            object[keyPath: objectKeyPath] = strongSelf.wrappedValue
        }.add(to: &disposal)
    }
    
    
    /// Bind wrappedValue to `objectKeyPath` property of type `T` in object `O` after apply transformation `transform`
    ///
    /// - Parameter object: Owner of the property
    /// - Parameter objectKeyPath: Keypath property
    /// - Parameter disposal: Observable container
    /// - Parameter transform: Transform wrappedValue before apply to the objectKeyPath property
    ///
    /// Sample :
    ///
    /// ```
    /// class SomeViewModel {
    ///     var username =  Observable("")
    /// }
    ///
    /// class ViewController {
    ///     self.viewModel.username.bind(to: self.usernameLabel, \.text, disposal: &self.disposal) { $0.uppercased() }
    /// }
    ///
    /// ```
    func bind<O: NSObject, R>(to object: O, _ objectKeyPath: ReferenceWritableKeyPath<O, R>, disposal: inout Disposal, transform: @escaping (T) -> R) {
        self.observe { [weak self] (new, old) in
            guard let strongSelf = self else { return }
            let value = strongSelf.wrappedValue
            object[keyPath: objectKeyPath] = transform(value)
        }.add(to: &disposal)
    }
    
    
    /// Bind **optional** wrappedValue to `objectKeyPath` property of type `R?` in object `O` after apply transformation `transform`
    ///
    /// - Parameter object: Owner of the property
    /// - Parameter objectKeyPath: Keypath property
    /// - Parameter disposal: Observable container
    /// - Parameter transform: Transform wrappedValue before apply to the objectKeyPath property
    ///
    /// Sample :
    ///
    /// ```
    /// class SomeViewModel {
    ///     var username =  Observable("")
    /// }
    ///
    /// class ViewController {
    ///     self.viewModel.username.bind(to: self.usernameLabel, \.text, disposal: &self.disposal) { $0.uppercased() }
    /// }
    ///
    /// ```
    ///
    func bind<O: NSObject, R>(to object: O, _ objectKeyPath: ReferenceWritableKeyPath<O, R?>, disposal: inout Disposal, transform: @escaping (T) -> R?) {
        self.observe { [weak self] (new, old) in
            guard let strongSelf = self else { return }
            let value = strongSelf.wrappedValue
            object[keyPath: objectKeyPath] = transform(value)
        }.add(to: &disposal)
    }
}
