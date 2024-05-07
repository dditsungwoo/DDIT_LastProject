package com.team1.workforest.vacation.util;

public enum VacationCategory {
	연차("1", "연차"),
    생일("2", "생일"),
    건강검진("3", "건강검진"),
    리프레시("4", "리프레시"),
    부모_배우자_자녀_조의("5", "조의 - 부모/배우자/자녀"),
    조부모_형제_자매_조의("6", "조의 - 조부모/형제/자매"),
    결혼("7", "결혼"),
    보건("8", "보건");

    private final String value;
    private final String description;

    VacationCategory(String value, String description) {
        this.value = value;
        this.description = description;
    }

    public String getValue() {
        return value;
    }

    public String getDescription() {
        return description;
    }

    public static VacationCategory fromValue(String value) {
        for (VacationCategory category : values()) {
            if (category.value.equals(value)) {
                return category;
            }
        }
        return null; 
    }

}
