public class ArraySort {
    private static int getValue(Object obj){
        if(obj instanceof Integer){
            return (int)(Integer)obj;
        }
        if(obj instanceof Character){
            return (int)(Character)obj;
        }
        if(obj instanceof String){
            return (int)obj.toString().charAt(0);
        }
        return 0;
    }

    private static void sortArray_shell(Object[] objects, int d){
        int i,j,inc;
        Object temp;
        for(inc = d; inc > 0; inc /= 2){
            for(i = inc; i < objects.length; i++){
                temp = objects[i];
                for(j = i - inc; j >= 0 && (getValue(temp) < getValue(objects[j])); j -= inc){
                    objects[j + inc] = objects[j];
                }
                objects[j + inc] = temp;
            }
        }
    }

    private static void displayArray(Object[] objects){
        StringBuffer strb = new StringBuffer();
        strb.append("[");
        for(int i = 0; i < objects.length; i++){
            strb.append(objects[i] + ",");
        }
        strb.setCharAt(strb.length() - 1, ']');
        String str = new String(strb);
        System.out.println(str);
    }

    public static void main(String[] args){
        Object[] objects_1 = {8,4,6,0,1,13};
        Object[] objects_2 = {8,'d',6,"abc",1000,1,13};
        System.out.print("示例1:\n输入:");
        displayArray(objects_1);
        sortArray_shell(objects_1,4);
        System.out.print("输出:");
        displayArray(objects_1);
        System.out.print("\n示例2:\n输入:");
        displayArray(objects_2);
        sortArray_shell(objects_2,4);
        System.out.print("输出:");
        displayArray(objects_2);
    }
}
