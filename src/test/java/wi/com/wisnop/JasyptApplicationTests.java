package wi.com.wisnop;
import org.jasypt.encryption.pbe.StandardPBEStringEncryptor;
import org.junit.jupiter.api.Test;

class JasyptApplicationTests {

    @Test
    void contextLoads() {
    }

    @Test
    void jasypt() {
        String url = "";
        String username = "";
        String password = "";

        System.out.println("url:" + jasyptEncoding(url));
        System.out.println("username:" + jasyptEncoding(username));
        System.out.println("password:" + jasyptEncoding(password));
    }

    public String jasyptEncoding(String value) {

        String key = "my_jasypt_key";
        StandardPBEStringEncryptor pbeEnc = new StandardPBEStringEncryptor();
        pbeEnc.setAlgorithm("PBEWithMD5AndDES");
        pbeEnc.setPassword(key);
        return pbeEnc.encrypt(value);
    }

}