(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	satellite1 - satellite
	instrument1 - instrument
	satellite2 - satellite
	instrument2 - instrument
	satellite3 - satellite
	instrument3 - instrument
	satellite4 - satellite
	instrument4 - instrument
	satellite5 - satellite
	instrument5 - instrument
	satellite6 - satellite
	instrument6 - instrument
	infrared3 - mode
	image0 - mode
	infrared4 - mode
	infrared2 - mode
	infrared1 - mode
	GroundStation0 - direction
	Star4 - direction
	GroundStation6 - direction
	Star5 - direction
	GroundStation1 - direction
	Star3 - direction
	GroundStation2 - direction
	Phenomenon7 - direction
	Phenomenon8 - direction
	Planet9 - direction
	Phenomenon10 - direction
	Phenomenon11 - direction
	Star12 - direction
	Phenomenon13 - direction
	Star14 - direction
	Planet15 - direction
	Phenomenon16 - direction
	Planet17 - direction
	Phenomenon18 - direction
	Planet19 - direction
)
(:init
	(supports instrument0 image0)
	(supports instrument0 infrared2)
	(supports instrument0 infrared1)
	(calibration_target instrument0 GroundStation2)
	(calibration_target instrument0 GroundStation6)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Phenomenon7)
	(supports instrument1 image0)
	(supports instrument1 infrared2)
	(calibration_target instrument1 Star3)
	(calibration_target instrument1 Star5)
	(on_board instrument1 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Star5)
	(supports instrument2 infrared1)
	(supports instrument2 infrared3)
	(calibration_target instrument2 GroundStation1)
	(calibration_target instrument2 Star5)
	(on_board instrument2 satellite2)
	(power_avail satellite2)
	(pointing satellite2 Star3)
	(supports instrument3 infrared1)
	(supports instrument3 infrared3)
	(supports instrument3 image0)
	(calibration_target instrument3 GroundStation6)
	(calibration_target instrument3 Star4)
	(on_board instrument3 satellite3)
	(power_avail satellite3)
	(pointing satellite3 Planet17)
	(supports instrument4 infrared3)
	(supports instrument4 image0)
	(supports instrument4 infrared1)
	(calibration_target instrument4 Star3)
	(calibration_target instrument4 Star5)
	(on_board instrument4 satellite4)
	(power_avail satellite4)
	(pointing satellite4 Planet15)
	(supports instrument5 infrared2)
	(supports instrument5 image0)
	(supports instrument5 infrared3)
	(calibration_target instrument5 Star3)
	(calibration_target instrument5 GroundStation1)
	(on_board instrument5 satellite5)
	(power_avail satellite5)
	(pointing satellite5 GroundStation6)
	(supports instrument6 image0)
	(supports instrument6 infrared4)
	(calibration_target instrument6 GroundStation2)
	(on_board instrument6 satellite6)
	(power_avail satellite6)
	(pointing satellite6 Star4)
)
(:goal (and
	(pointing satellite5 GroundStation0)
	(have_image Phenomenon7 infrared1)
	(have_image Phenomenon8 image0)
	(have_image Planet9 infrared1)
	(have_image Phenomenon10 infrared3)
	(have_image Phenomenon11 infrared2)
	(have_image Star12 infrared2)
	(have_image Phenomenon13 infrared2)
	(have_image Star14 infrared3)
	(have_image Planet15 infrared3)
	(have_image Phenomenon16 infrared3)
	(have_image Planet17 infrared4)
	(have_image Phenomenon18 infrared3)
	(have_image Planet19 infrared3)
))

)
