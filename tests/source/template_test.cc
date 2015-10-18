#include "gmock/gmock.h"
using ::testing::Eq;
using ::testing::StrEq;

TEST(TestSuiteName, TestDescription){
	EXPECT_THAT(1,Eq(1));
}
