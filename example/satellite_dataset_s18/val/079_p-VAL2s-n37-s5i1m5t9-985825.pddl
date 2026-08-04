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
	image4 - mode
	infrared3 - mode
	thermograph2 - mode
	thermograph1 - mode
	spectrograph0 - mode
	Star8 - direction
	Star1 - direction
	GroundStation7 - direction
	GroundStation4 - direction
	Star2 - direction
	GroundStation0 - direction
	GroundStation5 - direction
	GroundStation3 - direction
	GroundStation6 - direction
	Star9 - direction
	Planet10 - direction
	Star11 - direction
	Star12 - direction
	Phenomenon13 - direction
	Planet14 - direction
	Phenomenon15 - direction
	Planet16 - direction
	Star17 - direction
	Planet18 - direction
	Planet19 - direction
	Planet20 - direction
	Planet21 - direction
)
(:init
	(supports instrument0 image4)
	(supports instrument0 thermograph2)
	(calibration_target instrument0 GroundStation7)
	(calibration_target instrument0 GroundStation0)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star2)
	(supports instrument1 spectrograph0)
	(supports instrument1 image4)
	(supports instrument1 thermograph1)
	(calibration_target instrument1 GroundStation7)
	(calibration_target instrument1 GroundStation3)
	(calibration_target instrument1 Star1)
	(on_board instrument1 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Star2)
	(supports instrument2 spectrograph0)
	(supports instrument2 infrared3)
	(supports instrument2 image4)
	(calibration_target instrument2 GroundStation4)
	(calibration_target instrument2 GroundStation7)
	(calibration_target instrument2 GroundStation3)
	(on_board instrument2 satellite2)
	(power_avail satellite2)
	(pointing satellite2 GroundStation5)
	(supports instrument3 thermograph2)
	(supports instrument3 spectrograph0)
	(calibration_target instrument3 GroundStation0)
	(calibration_target instrument3 Star2)
	(on_board instrument3 satellite3)
	(power_avail satellite3)
	(pointing satellite3 GroundStation6)
	(supports instrument4 image4)
	(supports instrument4 infrared3)
	(calibration_target instrument4 GroundStation6)
	(calibration_target instrument4 GroundStation3)
	(calibration_target instrument4 GroundStation5)
	(on_board instrument4 satellite4)
	(power_avail satellite4)
	(pointing satellite4 Star1)
)
(:goal (and
	(pointing satellite0 GroundStation0)
	(pointing satellite1 Planet18)
	(pointing satellite4 Planet16)
	(have_image Star9 image4)
	(have_image Planet10 infrared3)
	(have_image Star11 spectrograph0)
	(have_image Star12 spectrograph0)
	(have_image Phenomenon13 thermograph2)
	(have_image Planet14 infrared3)
	(have_image Phenomenon15 spectrograph0)
	(have_image Planet16 thermograph2)
	(have_image Star17 infrared3)
	(have_image Planet18 image4)
	(have_image Planet19 spectrograph0)
	(have_image Planet20 thermograph2)
	(have_image Planet21 infrared3)
))

)
