-- shared structures of CAS services
-- by mike
-- v2025.0711

return {
    ["BadgeService"] = {
        Methods = {
            -- the only apis we would really use
            -- there are more methods that RCCService used
            "UserHasBadge",
            "IsLegal",
            "IsDisabled",
            "AwardBadge"
        },

        Variables = {
            "BadgeAwarded"
        }
    },

	["HttpService"] = {
        Methods = {
            "GenerateGUID",
            "GetAsync",
            "JSONDecode",
			"JSONEncode",
			"PostAsync",
			"UrlEncode"
        },

        Variables = {
            "HttpEnabled"
        }
    },

	["HttpRbxApiService"] = {
        Methods = {
            "GetAsync", -- we're not adding functions from 2018+
            "PostAsync"
        },

		Variables = {}
    },

	["MarketplaceService"] = {
		-- i'm not adding 2016-2017 functions yet.
        Methods = {
            "GetProductInfo",
            "PlayerOwnsAsset",
            "PromptPurchase",
			"SignalPromptPurchaseFinished",
			"PromptProductPurchase",
			"SignalClientPurchaseSuccess",
			"SignalPromptProductPurchaseFinished",
			"SignalServerLuaDialogClosed",
			"ProcessReceipt",
			"PromptThirdPartyPurchase",
			"PromptNativePurchase",
			"GetDeveloperProductsAsync"
        },

        Variables = {
            "PromptPurchaseFinished",
			"PromptPurchaseRequested",
			"ClientPurchaseSuccess",
			"PromptProductPurchaseFinished",
			"PromptProductPurchaseRequested",
			"ServerPurchaseVerification",
			"ClientLuaDialogRequested",
			"ThirdPartyPurchaseFinished",
			"NativePurchaseFinished"
        }
    },

	["LogService"] = {
		-- no 2016-2018 methods yet!
		Methods = {
			"ExecuteScript",
			"RequestServerOutput",
			"GetLogHistory",
		},

		Variables = {
			"MessageOut",
			"ServerMessageOut",
		}
	}
}