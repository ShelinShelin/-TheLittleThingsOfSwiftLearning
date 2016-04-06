#The Little Things Of Swift Learning

###Grammar（语法基础）
######Optional（可选类型）

- Swift里不会自动给定义的变量赋初始值，也就是说变量不会有默认值（区别于OC，例如OC中定义一个整型变量不赋初值默认为0），所以要求使用变量之前必须要对其初始化。如果在使用变量之前不进行初始化就会报错。
- Optional，可选类型，一个枚举类型enum，有Some和None两种类型，Optional.None对应nil，Optional.Some对应非nil，以下是Optional的定义：
```
public enum Optional<Wrapped> : _Reflectable, NilLiteralConvertible {
    case None
    case Some(Wrapped)
    /// Construct a `nil` instance.
    public init()
    /// Construct a non-`nil` instance that stores `some`.
    public init(_ some: Wrapped)
    /// If `self == nil`, returns `nil`.  Otherwise, returns `f(self!)`.
    @warn_unused_result
    public func map<U>(@noescape f: (Wrapped) throws -> U) rethrows -> U?
    /// Returns `nil` if `self` is nil, `f(self!)` otherwise.
    @warn_unused_result
    public func flatMap<U>(@noescape f: (Wrapped) throws -> U?) rethrows -> U?
    /// Create an instance initialized with `nil`.
    public init(nilLiteral: ())
}
```
- 在声明一个变量的时候不确定是否有值，所以可能有值，也可能为nil，这时候需要使用?声明为Optional，?紧跟在变量类型后面（注意：中间不允许有空格），如果不显示（开发者主动赋值）的赋值就会有个默认值nil，下面定义一个可选类型的UILabel：
```
var label : UILabel?   //必须指定数据类型，否则报错
```
- 当访问变量的相关方法、属性、下标时也需要加上？，意思是询问是否响应后面这个方法，如果是nil值，也就是Optional.None，固然不能响应后面的方法，所以就会跳过，如果有值，就是Optional.Some，可能就会拆包(unwrap)，然后对拆包后的值执行后面的操作，类似OC中判断是否执行某个方法isResponseToSelector，下面我们访问UILabel的text属性：
```
 label?.text = "is a label"
```
  以上是?的两种使用场景：1、声明Optional修饰的变量，表示可选类型。
                        2、根据Optional的值，来决定是否执行后续操作，需要拆包(unwrap)才能得到值
 
- !的使用，用!修饰是隐式可选类型，上面说到需要拆包才能得到Optional的值，有两种拆包方式
  1、强制拆包（forced unwrapping）：
```
let text = label!.text 
```
  上面语法表示该变量一定不为nil，允许执行后续的操作，但是如果变量为空的话会直接crash，称为强制拆包。
  2、可选绑定（Optional Binding）：


   这么做的目的：一是让代码更明确，让开发者先想清楚再编程， 二是给编译器提供更多信息，在编译时发现更多潜在错误，更加安全。

 
 
