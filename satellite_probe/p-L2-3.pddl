(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	instrument2 - instrument
	satellite1 - satellite
	instrument3 - instrument
	instrument4 - instrument
	spectrograph0 - mode
	image2 - mode
	infrared1 - mode
	Star2 - direction
	GroundStation8 - direction
	Star9 - direction
	Star13 - direction
	Star6 - direction
	Star0 - direction
	GroundStation7 - direction
	Star5 - direction
	GroundStation1 - direction
	Star11 - direction
	Star14 - direction
	Star12 - direction
	Star10 - direction
	Star3 - direction
	GroundStation4 - direction
	Planet15 - direction
	Planet16 - direction
	Phenomenon17 - direction
	Star18 - direction
	Phenomenon19 - direction
	Planet20 - direction
	Star21 - direction
	Star22 - direction
)
(:init
	(supports instrument0 image2)
	(calibration_target instrument0 Star5)
	(calibration_target instrument0 GroundStation7)
	(calibration_target instrument0 Star10)
	(calibration_target instrument0 Star0)
	(calibration_target instrument0 Star6)
	(supports instrument1 image2)
	(supports instrument1 spectrograph0)
	(supports instrument1 infrared1)
	(calibration_target instrument1 GroundStation1)
	(calibration_target instrument1 Star10)
	(supports instrument2 image2)
	(calibration_target instrument2 Star11)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(on_board instrument2 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Phenomenon17)
	(supports instrument3 image2)
	(calibration_target instrument3 GroundStation4)
	(supports instrument4 spectrograph0)
	(supports instrument4 infrared1)
	(supports instrument4 image2)
	(calibration_target instrument4 GroundStation4)
	(calibration_target instrument4 Star3)
	(calibration_target instrument4 Star10)
	(calibration_target instrument4 Star12)
	(calibration_target instrument4 Star14)
	(on_board instrument3 satellite1)
	(on_board instrument4 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Phenomenon19)
)
(:goal (and
	(pointing satellite0 Planet20)
	(have_image Planet15 infrared1)
	(have_image Planet16 spectrograph0)
	(have_image Phenomenon17 infrared1)
	(have_image Star18 spectrograph0)
	(have_image Phenomenon19 infrared1)
	(have_image Planet20 spectrograph0)
	(have_image Star21 image2)
	(have_image Star22 image2)
))

)
