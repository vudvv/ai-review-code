import java.util.Scanner

fun main(args: Array<String>) {
    val reader = Scanner(System.`in`)
    print("Enter a number: ")

    var integer:Int = reader.nextInt()

    println("You entered: $integer")
}