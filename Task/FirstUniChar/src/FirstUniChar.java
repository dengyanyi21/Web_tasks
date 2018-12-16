import java.util.Scanner;

public class FirstUniChar {
    private static int firstUniChar(String str){
        int[] hashValue = new int[26];
        int i;
        for(i = 0; i < str.length(); i++){
            hashValue[str.charAt(i) - 'a']++;
        }
        for(i = 0; i < str.length(); i++){
            if(hashValue[str.charAt(i) - 'a'] == 1){
                return i;
            }
        }
        return -1;
    }

    public static void main(String[] args){
        Scanner input = new Scanner(System.in);
        System.out.print("输入字符串：");
        String tempStr = input.next();
        int index = firstUniChar(tempStr);
        System.out.println("返回 " + index + ".");
    }
}
