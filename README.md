#The Little Things Of Swift Learning

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

######Swift面向协议编程
 
 协议相对继承的优势：
 - 一个类、结构体、枚举可以遵循多个继承，可以得到不同协议的默认属性或者方法实现，而OC中只允许单继承
 - 类、结构体、枚举都可以遵循协议，而继承只有类可以，其实也就是说协议可以为所有值类型的增加默认的属性和功能，更加全面
 - 继承会将所有父类的属性和方法强制的给所有子类，耦合度高，一处的改动对所有子类都会造成影响。协议更加灵活，你可以给需要这些属性和方法的类型遵循这个协议，协议也可以对遵循者用where语法去加限制条件，满足条件才能遵循，否则编译器报错
 - 协议也能继承，继承父类的方法和属性，协议也能合并成一种新的协议类型，使新的协议同时拥有两种甚至多种的协议的方法和属性


##了解Swift中的枚举、结构和类（翻译）
原文：https://www.raywenderlich.com/119881/enums-structs-and-classes-in-swift
　　
　　
　　在以前我们只用Objective-C开发的时候，封装仅限于处理某个类。可是在现在用Swift开发iOS、Mac应用我们有三种选择：**Enums**、**Structs**、**Classes**。

![enums-structs-classes-feature.png](http://upload-images.jianshu.io/upload_images/1121012-aa0cdee5bc195144.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
　　
　　这些类型结合协议一起使用让我们可以创造一些不可思议的事，虽然它们有很多通用、相似的作用，但是也有很多重要的区别。
这个教程的目的是:
- 提供一些关于使用**Enums**、**Structs**、**Classes**的经验
- 告诉你使用它们的时机
- 以及每种类型是怎样工作的

　　这个教程基于你至少对Swift或者对面向对象编程有一些经验。
####关于这些类型
Swift中最大的三个卖点就是：**安全**、**迅速**、**简单**。安全意味着你不能胡作非为的写代码、消耗内存、制造很难被发现的Bug，Swift更安全是因为它会试图在代码编译期发现你的问题，而不是在运行期抛出异常。
　　此外，Swift让你更清楚的表达你的意图，优化你的代码使其运行的更快，Swift的核心是简单、但高度规范化，尽管它相对简单、小数量的的规则，你会发现做了很多不错的事。能够产生这样效果的关键是Swift的**类型系统**（type system）

![types-480x134.png](http://upload-images.jianshu.io/upload_images/1121012-4e95a4615e988e82.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

　　Swift的类型非常强大，尽管它只有六种（应该理解为基本类型除外），不像其他语言有built-in类型。
　　它包括四种命名类型：**Protocol**、**Enums**、**Structs**、**Classes**，两种符合类型：**Tuple**、**Function**。
　　还有被称为基本类型的，例如： **Bool**, **Int**, **UInt**, **Float**, **Double**, **Character**, **String**,** Array**, **Set**, **Dictionary**, **Optional**等，这实际上是基于命名类型和Swift的一部分系统标准库。
　　本教程的重点是所谓的命名模型类型包括枚举，结构体和类。
####可缩放矢量的图形形状(SVG)
　　作为展示如何工作的例子，你创建一个安全、迅速、简单的可缩放矢量的图形形状的渲染框架。
　　SVG是一种基于xml的2d图形的矢量图像格式。这个规范已经自1999年以来由W3C开发的开放标准。
####现在开始
　　打开Xcode选择**File\New\Playground**新建一个Playground文件，把它命名为**Shapes**，运行平台选择**OS X**，然后下一步保存，清空文件输入以下：
```
import Foundation
```
你的目的是为了能够显示这样（一段带标签的字符串）：
```
<!DOCTYPE html><html><body><svg width='250' height='250'><rect x='110.0' y='10.0' width='100.0' height='130.0' stroke='Teal' fill='Aqua' stroke-width='5' /><circle cx='80.0' cy='160.0' r='60.0' stroke='Red' fill='Yellow' stroke-width='5'  /></svg></body></html>
```
这看起来还不错当你用浏览器或者WebKit view打开，相信我。
　　你需要表示一种颜色，SVG使用CSS3的颜色类型，可以Name，RGB或HSL。完整的规范：http://www.w3.org/TR/css3-color/
给图形其中一个属性指定颜色，例如：```fill = 'Gray'```，这用字符串简单的表示```let fill = "Gray"```
![color_rage.png](http://upload-images.jianshu.io/upload_images/1121012-bebdc701ca293bb2.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

当你用字符串来实现很简单，但是存在重大的缺陷：
- 1、这很容易出错，任意不是颜色的字符串能通过编译但运行起来不能正确显示，例如，将```"gray"```其中一个字母拼成“e”是行不通的。
- 2、不会自动提示帮助你找到有效的颜色名称。
- 3、当你传入一个颜色作为参数，它可能并不总是显而易见的告诉你这个字符串是一个颜色。

你可能会想像这样实现它：
```
enum ColorName { 
    case Black 
    case Silver 
    case Gray 
    case White 
    case Maroon 
    case Red // 
    ... and so on ...
 }
```
　　看起来非常类似于一组C语言风格的枚举。可是又不像C语言的枚举，Swift给每个选项指定类型来表示，枚举被明确的指定某种存储类型称为**RawRepresentable**，因为它自动的遵循了**RawRepresentable**协议。
　　所以，你可以把ColorName的类型指定为字符串，并赋值，就像：
```
enum ColorName : String { 
    case Black = "Black" 
    case Silver = "Silver" 
    case Gray = "Gray" 
    case White = "White" 
    case Maroon = "Maroon" 
    case Red = "Red" // 
    ... and so on ... 
}
```
　　然而，Swift对于字符串来表示的枚举做了一些特殊操作。如果你不指定枚举的选项等于什么，编译器会自动让它等用于和选项名一样的字符串。这意味着你只需要写选项的名称：
```
enum ColorName { 
    case Black 
    case Silver 
    case Gray 
    case White 
    case Maroon 
    case Red // 
    ... and so on ...
 }
```
你可以进一步减少输入，用逗号分开的选项，再开有使用一次关键字。在playground中加上下面这段代码：
```
enum ColorName : String {
     case Black, Silver, Gray, White, Maroon, Red, Purple, Fuchsia, Green, Lime, Olive, Yellow, Navy, Blue, Teal, Aqua
}
```
现在你有了自定义的一个结构体类型，这看起来很棒，比如：
```
let fill = ColorName.Grey // ERROR: Misspelled color names won't compile. Good!
let fill = ColorName.Gray // Correct names autocomplete and compile. Yay!
```
####关联值
　　使用ColorName时有利于命名颜色的，但你可能还记得，CSS颜色有几个表示：Name，RGB或HSL等等。你怎么转化成模型？
枚举在Swift中非常适合建模，比如CSS的颜色，以及每个枚举可以搭配自己的数据。这些数据被称为关联值。
在playground定义一个CSSColor的枚举：
```
enum CSSColor {
    case Named(ColorName)
    case RGB(UInt8, UInt8, UInt8)
}
```
定义并给CSSColor模型两种状态：
- 1、它可以指定一个名字，在这种情况下，关联值是ColorName
- 2、它可以是RGB，这个情况下，关联值是三个UInt8类型表示红、绿、蓝的数字。

注意这个例子为了简洁遗漏了RGBA、HSL和HSLA的情况。
####枚举的协议和方法

![protocol.png](http://upload-images.jianshu.io/upload_images/1121012-899e20a6b34731ec.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

　　你希望能够打印出CSSColor的多个实例，在Swift中枚举就像其他命名类型可以采用协议。遵循**CustomStringConvertible**协议你的类型可以神奇地使用print语句打印。
　　Swift标准库之间的互相操作的关键是遵循标准库协议。
　　在playground中添加CSSColor的扩展:
```
extension CSSColor : CustomStringConvertible { 
    var description: String { 
        switch self { 
            case .Named(let colorName): 
                return colorName.rawValue 
            case .RGB(let red, let green, let blue): 
                return String(format: "#%02X%02X%02X", red,green,blue) 
        }
    }
}
```
　　让CSSColor遵循**CustomStringConvertible**协议，这告诉Swift这个CSSColor类型可以转化为字符串类型，我们来告诉怎么实现**description**计算属性。
self会在switch中确定模型是一个Name或RGB类型，在每种情况下将颜色转换为所需的字符串格式，Name的情况将返回颜色字符串名称，而RGB的情况返回红色，绿色和蓝色值所需的格式。
把以下加到你的playground中：
```
let color1 = CSSColor.Named(.Red)
let color2 = CSSColor.RGB(0xAA, 0xAA, 0xAA)
print("color1 = \(color1), color2 = \(color2)")  // prints color1 = Red, color2 = #AAAAAA
```
一切都是在编译期检查类型的正确性，和它是如何当你只使用字符串值代表颜色，并不像你用**String**来表示颜色的时候。

>**提醒**：
　　虽然你可以回到你以前的定义CSSColor的地方修改它，但你不要这么做，你可以使用一个扩展颜色类型和采用新的协议。
　　使用扩展更好因为它使符合给定的协议更加明确。在遵循CustomStringConvertible的情况下，你只需要实现字符串description属性的gtter方法。

####初始化一个枚举
　　就像Swift中的类、结构体一样，你也可以给枚举自定义一个初始化的方法，例如，为灰度值自定义初始化方法。
```
extension CSSColor { 
    init(gray: UInt8) { 
        self = .RGB(gray, gray, gray)     
    }
}
```

```
let color3 = CSSColor(gray: 0xaa)
print(color3) // prints #AAAAAA
```
 现在你可以通过传入灰度值方便地创建颜色了！
####枚举的命名空间
