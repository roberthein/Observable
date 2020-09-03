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
    ///     viewModel.username.bind(to: usernameLabel, \.text, disposal: &disposal)
    /// }
    ///
    /// ```
    ///
    func bind<O>(to object: O, _ objectKeyPath: ReferenceWritableKeyPath<O, T>, disposal: inout Disposal) {
        observe { [weak self] (new, old) in
            guard let self = self else { return }
            object[keyPath: objectKeyPath] = self.wrappedValue
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
    ///     viewModel.username.bind(to: usernameLabel, \.text, disposal: &disposal)
    /// }
    ///
    /// ```
    ///
    func bind<O>(to object: O, _ objectKeyPath: ReferenceWritableKeyPath<O, T?>, disposal: inout Disposal) {
        observe { [weak self] (new, old) in
            guard let self = self else { return }
            object[keyPath: objectKeyPath] = self.wrappedValue
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
    ///     viewModel.username.bind(to: usernameLabel, \.text, disposal: &disposal) { $0.uppercased() }
    /// }
    ///
    /// ```
    func bind<O: NSObject, R>(to object: O, _ objectKeyPath: ReferenceWritableKeyPath<O, R>, disposal: inout Disposal, transform: @escaping (T) -> R) {
        observe { [weak self] (new, old) in
            guard let self = self else { return }
            let value = self.wrappedValue
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
    ///     viewModel.username.bind(to: usernameLabel, \.text, disposal: &disposal) { $0.uppercased() }
    /// }
    ///
    /// ```
    ///
    func bind<O: NSObject, R>(to object: O, _ objectKeyPath: ReferenceWritableKeyPath<O, R?>, disposal: inout Disposal, transform: @escaping (T) -> R?) {
        observe { [weak self] (new, old) in
            guard let self = self else { return }
            let value = self.wrappedValue
            object[keyPath: objectKeyPath] = transform(value)
        }.add(to: &disposal)
    }
}
