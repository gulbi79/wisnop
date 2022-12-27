package wi.com.wisnop.security.dto;

import java.io.Serializable;

import lombok.AccessLevel;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

/**
 * 비즈니스 로직 중 '로그인'에 사용이 되는 Model 객체를 생성합니다.
 * @author sung
 *
 */
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class UserDto implements Serializable {
    private int userSq;
    private String userId;
    private String userPw;
    private String userNm;
    private String userSt;
    private String userPwCompareYn;
    private String langCd;

    @Builder
    UserDto(int userSq, String userId, String userPw, String userNm, String userSt, String userPwCompareYn, String langCd) {
        this.userSq = userSq;
        this.userId = userId;
        this.userPw = userPw;
        this.userNm = userNm;
        this.userSt = userSt;
        this.userPwCompareYn = userPwCompareYn;
        this.langCd = langCd;
    }
}