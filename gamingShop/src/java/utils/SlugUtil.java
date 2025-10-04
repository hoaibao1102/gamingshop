/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package utils;

import java.text.Normalizer;
import java.util.Locale;

/**
 *
 * @author ADMIN
 */
public class SlugUtil {
    public static String toSlug(String input, int id) {
        // 1. Chuyển Unicode có dấu sang dạng tổ hợp (NFD)
        String normalized = Normalizer.normalize(input, Normalizer.Form.NFD);

        // 2. Xóa hết dấu tiếng Việt (các ký tự tổ hợp)
        String withoutDiacritics = normalized.replaceAll("\\p{InCombiningDiacriticalMarks}+", "");

        // 3. Bỏ ký tự đặc biệt, chỉ giữ chữ, số và khoảng trắng
        String clean = withoutDiacritics.replaceAll("[^a-zA-Z0-9\\s-]", "");

        // 4. Replace khoảng trắng bằng dấu -
        String slug = clean.trim().toLowerCase(Locale.ROOT)
                .replaceAll("\\s+", "-")
                .replaceAll("-+", "-");

        // 5. Thêm id cuối để unique (nếu cần)
        if (id > 0) {
            slug = slug + "-" + id;
        }

        return slug;
    }

    public static void main(String[] args) {
        String name = "MÁY CHƠI GAME NINTENDO SWITCH LITE PRO (MODCHIP) HÀNG 2ND";
        System.out.println(toSlug(name, 27));
    }
}
