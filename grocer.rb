def consolidate_cart(cart)
	item_counts = {}

	cart.each do |item_hash|
		item_hash.each do |item, info|
			item_counts[item] = info
			item_counts[item][:count] = 0
		end
	end

	cart.each do |item_hash|
		item_hash.each do |item, info|
			count = item_counts[item][:count]
			item_counts[item][:count] = count + 1
		end
	end

	item_counts
end

def apply_coupons(cart, coupons)
	coupons.each do |coupon|
		item = coupon[:item]

		if cart.include?(item)
			if cart[item][:count] >= coupon[:num]
				updated_name = item + " W/COUPON"

				if cart.has_key?(updated_name)
					cart[updated_name][:count] += 1
				else
					price = coupon[:cost]
					clearance = cart[item][:clearance]
					cart[updated_name] = {price: price, clearance: clearance, count: 1}
				end

				coupon_num = coupon[:num]
				cart[item][:count] = cart[item][:count] - coupon_num
			end
		end
	end

	cart
end

def apply_clearance(cart)
	cart.each do |item, info|
		if info[:clearance]
			info[:price] = info[:price] - info[:price] * 0.2
		end
	end

	cart
end

def checkout(cart, coupons)
	updated_cart = consolidate_cart(cart)
	updated_cart = apply_coupons(updated_cart, coupons)
	updated_cart = apply_clearance(updated_cart)

	total = 0.0

	updated_cart.each do |item, info|
		item_total = info[:price] * info[:count]
		total += item_total
	end

	if total > 100
		total = total - total * 0.1
	end

	total
end
