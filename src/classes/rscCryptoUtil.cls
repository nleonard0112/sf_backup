public with sharing class rscCryptoUtil {
    
    private static String kHexChars = '0123456789abcdefABCDEF';
    
    public static String randomUUID(){
        String returnValue = '';
        Integer nextByte = 0;
        for(Integer i = 0; i < 16; i++){
            if(i==4 || i==6 || i==8 || i==10){
                returnValue += '-';
            }
            //generate a "byte"; i.e., number in range [-2^7,2^7-1]
            nextByte = (Math.round(Math.random() * 255)-128) & 255;

            if(i==6){
                nextByte = nextByte & 15;
                nextByte = nextByte | (4 << 4);
            }
            if(i==8){
                nextByte = nextByte & 63;
                nextByte = nextByte | 128;
            }

            returnValue += charAt(kHexChars,nextByte >> 4);
            returnValue += charAt(kHexChars,nextByte & 15);
        }
        return returnValue;
    }

    private static String charAt(String str, Integer index) {
        if (str == null) return null;
        if (str.length() <= 0) return str;    
        if (index == str.length()) return null;    
        return str.substring(index, index+1);
    }

    public static String randomAESKey() {
        Blob key = Crypto.generateAesKey(256);
        return EncodingUtil.base64Encode(key);
    }
}